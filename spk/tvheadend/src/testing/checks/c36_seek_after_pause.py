"""Seeking after pausing, up to just short of live.

What a viewer does: watches live, goes back a little and returns to live,
watches on while a recording of the channel starts, pauses and resumes a
couple of times, then moves to the end of the seek bar -- Kodi's right arrow
held to the end, which it sends as one absolute seek just short of live, and
follows with 4x when the picture does not move.  Pausing takes the
client off live, and the server then works out how the client's timestamps
relate to the cache's; every seek after relies on that.  A seek just short of
live, which the replay may not reach before the head of the cache, is to be
answered too -- as live, when there is nothing newer to land on.  Before,
such a seek was never answered: the client froze on its last picture and its
subscription sent nothing.

On a subscription of its own: 30 s live, a 20 s rewind and back to live,
30 s live, a recording of the channel started and 40 s more live, then pause
60 s, play 10 s, pause 10 s, play 30 s.  Straight after, as Kodi does, an
absolute seek 0.5 s short of the end followed 5 s later by 4x must be
answered and followed by packets; then an absolute seek 30 s
short of the end must land within 2 s of where it asked, and one 5 s past
the end -- the other way to ask for the end of the bar -- must be answered
and followed by packets.  The recording is removed.  When nobody else uses the server, the RAM budget is lowered to
16 MB for the while, so that the client, a minute behind, reads from the
part of the cache on disk and the seek takes it into the part in RAM; the
setting is put back.
"""
import time

from common import PASS, FAIL
import htsp as H

NUMBER, TITLE = 36, "seeking after pausing, up to just short of live"
SID = 91
SLACK = 2.0
SETTINGS = ("ram_only", "ram_size")


class _Viewer:
    """A subscription that keeps the last timeshift status, the skip
    replies and a count of packets."""

    def __init__(self, ctx):
        self.h = ctx.connect()
        H._subscribe(self.h, SID, ctx.chan_id)
        self.status = {}
        self.replies = []
        self.packets = 0

    def pump(self, seconds):
        end = time.time() + seconds
        while time.time() < end:
            m = self.h.recv(1)
            if not m or m.get("subscriptionId") not in (None, SID):
                continue
            method = m.get("method")
            if method == "timeshiftStatus":
                self.status = m
            elif method == "subscriptionSkip":
                self.replies.append(m)
            elif method == "muxpkt":
                self.packets += 1

    def send(self, **kw):
        self.h.send(subscriptionId=SID, **kw)

    def seek(self, wait, **kw):
        """Ask for a seek; the reply, or None when none came within `wait`."""
        self.replies = []
        self.send(method="subscriptionSkip", **kw)
        end = time.time() + wait
        while time.time() < end and not self.replies:
            self.pump(0.5)
        return self.replies[0] if self.replies else None

    def close(self):
        try:
            self.send(method="unsubscribe")
            self.pump(2)
            self.h.s.close()
        except Exception:
            pass


def _at(reply):
    if not reply or reply.get("error"):
        return None
    return reply.get("time", 0) / 1e6


def run(ctx):
    return sequence(ctx, live_for=30, recording_for=40, pause_for=60)


def sequence(ctx, live_for, recording_for, pause_for, lower_ram=True):
    """The viewer's way to the end of the bar: `live_for` s live after the
    first excursion, a recording started and `recording_for` s more live,
    then a pause of `pause_for` s and a shorter one.  With `lower_ram`, and
    nobody else on the server, the RAM budget is 16 MB meanwhile."""
    ctx.drop_warm()
    busy = ctx.server_in_use()
    if not lower_ram:
        busy = busy or "the RAM budget kept as it is"
    before = ctx.timeshift()
    if not busy:
        ctx.timeshift(ram_only=False, ram_size=16)
    v = _Viewer(ctx)
    rec = None
    try:
        v.pump(30)
        if _at(v.seek(20, time=-20000000)) is None:
            return FAIL, "the first rewind was refused"
        v.pump(10)
        v.send(method="subscriptionSpeed", speed=100)
        v.seek(20, time=3600000000)       # back to live
        v.pump(live_for)
        now = int(ctx.now())
        rec = ctx.create_entry(start=now, stop=now + recording_for + pause_for + 600,
                               title={"eng": "seek after pause check"})
        v.pump(recording_for)
        for speed, secs in ((0, pause_for), (100, 10), (0, 10), (100, 30)):
            v.send(method="subscriptionSpeed", speed=speed)
            v.pump(secs)

        problems = []
        end = v.status.get("end")
        if end is None:
            return FAIL, "no timeshift status after pausing"
        v.replies = []
        v.send(method="subscriptionSkip", time=end - 500000, absolute=1)
        v.pump(5)
        v.send(method="subscriptionSpeed", speed=400)
        seen = v.packets
        v.pump(15)
        after = v.packets - seen
        near = v.replies[0] if v.replies else None
        if near is None:
            problems.append("the seek 0.5 s short of live was never answered")
        elif near.get("error"):
            problems.append("the seek 0.5 s short of live was refused")
        if after == 0:
            problems.append("nothing came after it")

        v.send(method="subscriptionSpeed", speed=100)
        v.pump(5)
        end = v.status.get("end", end)
        target = end - 30000000
        landed = _at(v.seek(20, time=target, absolute=1))
        if landed is None:
            problems.append("the seek 30 s back was refused")
        elif abs(landed - target / 1e6) > SLACK:
            problems.append("the seek 30 s back landed %+.1f s from where it asked"
                            % (landed - target / 1e6))

        v.pump(5)
        end = v.status.get("end", end)
        past = v.seek(20, time=end + 5000000, absolute=1)
        seen = v.packets
        v.pump(5)
        past_packets = v.packets - seen
        if _at(past) is None:
            problems.append("the seek past the end was %s"
                            % ("refused" if past else "never answered"))
        elif past_packets == 0:
            problems.append("nothing came after the seek past the end")

        detail = ("%s; 0.5 s short of live: %s, then %d packets in 15 s; 30 s back: %s; "
                  "5 s past the end: %s, then %d packets in 5 s") % (
            "from disk to RAM (16 MB of RAM)" if not busy
            else "RAM left as it is (%s)" % busy,
            "answered" if near and not near.get("error") else "no answer", after,
            "landed %+.1f s from the target" % (landed - target / 1e6)
            if landed is not None else "refused",
            "answered" if _at(past) is not None else "no answer", past_packets)
        return (FAIL, "; ".join(problems) + " -- " + detail) if problems else (PASS, detail)
    finally:
        v.send(method="subscriptionSpeed", speed=100)
        v.close()
        ctx.drop_entry(rec)
        if not busy:
            ctx.timeshift(**{k: before.get(k) for k in SETTINGS})
