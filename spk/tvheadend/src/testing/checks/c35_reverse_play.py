"""Playing backwards, and seeking while doing so.

A client that sets a negative speed is played backwards from keyframe to
keyframe -- any packet on a radio service, which has no video to anchor on.
A seek made meanwhile goes back from where it asks, not from the last frame
shown.  Before, a radio service could not be played backwards at all: with
no keyframe to find, the server went back to the start of the cache and
paused there.

The check rewinds a little, plays backwards at twice the speed for a few
seconds and expects the timestamps it receives to go down, then seeks 15 s
further back while still going backwards and expects an answer no later than
where it was -- the first frame there is, if that is the start of what may be
reached; it then returns to live.
"""
import time

from common import PASS, FAIL
import htsp as H

NUMBER, TITLE = 35, "playing backwards, and seeking meanwhile"


def _times(h, seconds):
    """The pts of the packets received for a while, in seconds."""
    out = []
    end = time.time() + seconds
    while time.time() < end:
        m = h.recv(1)
        if m and m.get("method") == "muxpkt" and m.get("pts") is not None:
            out.append(m["pts"] / 1e6)
    return out


def run(ctx):
    h, sid = ctx.warm()
    try:
        # off live first, so that there is somewhere to go back from
        start = ctx.position(ctx.skip(h, sid, seconds=-10))
        if start is None:
            return FAIL, "the first rewind was refused"
        _times(h, 2)
        h.send(method="subscriptionSpeed", subscriptionId=sid, speed=-200)
        ts = _times(h, 6)
        back = len(ts) >= 3 and ts[-1] < ts[0] - 1
        r = ctx.skip(h, sid, seconds=-15)
        landed = ctx.position(r)
        problems = []
        if not back:
            problems.append("not played backwards (%d packets%s)" % (
                len(ts), ", %.1f s to %.1f s" % (ts[0], ts[-1]) if ts else ""))
        if landed is None:
            problems.append("the seek made while going back was refused")
        elif ts and landed > ts[-1] + 1:
            # at the start of what may be reached, the first frame there is
            problems.append("the seek landed at %.1f s, after %.1f s where it was"
                            % (landed, ts[-1]))
        detail = "from %.1f s, %s; a 15 s seek meanwhile landed at %s" % (
            start, "%.1f s down to %.1f s" % (ts[0], ts[-1]) if ts else "no packet",
            "%.1f s" % landed if landed is not None else "nothing")
        return (FAIL, "; ".join(problems) + " -- " + detail) if problems else (PASS, detail)
    finally:
        h.send(method="subscriptionSpeed", subscriptionId=sid, speed=100)
        ctx.skip(h, sid, seconds=3600)
        ctx.pump(h, 2)
