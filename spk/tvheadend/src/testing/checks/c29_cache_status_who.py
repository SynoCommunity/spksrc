"""What the cache status says of who is in a cache.

The web interface draws each viewer of a cache where it stands, as playing or
paused and saying who it is, and each recording as the part of the cache its
programme is made of.  A recording that starts on time reads the cache live,
through no replay gate, and the status once failed to count it as a recording
at all.

This check pauses its client, schedules a two-minute recording on the same
channel that starts on time, and holds api/status/caches and
api/status/subscriptions to them: the paused client listed as paused, with its
client and address; the recording listed live, with its programme's span; the
bytes it is made of counted, in the cache and in the budget; and the
recording's own subscription named a recording of that cache.  The recording is
deleted and the client resumed and taken back to live afterwards.  A build
without these fields reports absent.
"""
import time

from common import PASS, FAIL, ABSENT

NUMBER, TITLE = 29, "the cache status names a paused viewer and a live recording"

TITLE_REC = "tvh-check-29"


def run(ctx):
    if "entries" not in ctx.jload("/status/caches"):
        return ABSENT, "this build has no api/status/caches"
    h, sid = ctx.warm()
    e = ctx.cache_entry()
    if e is None:
        return FAIL, "no cache listed for the channel's services"
    if "paused" not in e or "recorded" not in e:
        return ABSENT, "this build's cache status has no paused or recorded fields"

    uuid = None
    try:
        h.send(method="subscriptionSpeed", subscriptionId=sid, speed=0)
        ctx.pump(h, 3)
        now = int(ctx.now())
        start, stop = now + 15, now + 135
        uuid = ctx.create_entry(start=start, stop=stop, title={"eng": TITLE_REC},
                                start_extra=0, stop_extra=0)
        if not uuid:
            return FAIL, "could not schedule the recording"

        rec_sub = me = None
        rec_bytes = 0
        end = time.time() + 90
        while time.time() < end:
            ctx.pump(h, 5)
            e = ctx.cache_entry() or {}
            subs = ctx.subscriptions(mine=True)
            rec_sub = next((s for s in subs
                            if (s.get("title") or "").startswith("DVR: " + TITLE_REC)), None)
            me = next((s for s in subs
                       if s.get("username") == ctx.user and s.get("cache_paused")), None)
            rb = e.get("recorded_bytes") or {}
            rec_bytes = sum(rb.get(k, 0) for k in ("ram", "staging", "disk"))
            if e.get("recordings") and rec_sub and rec_sub.get("cache_role") and rec_bytes > 0:
                break
            # a recording that cannot write its file ends at once: the
            # server is not set up for the check, which says nothing of
            # the cache status
            ent = ctx.entry(uuid)
            if ent.get("sched_status") in ("completedError", "completed") \
                    or "not created" in str(ent.get("status") or ""):
                return (ABSENT, "the recording ended before it could be seen (%s): "
                                "the DVR profile needs a path it can write to"
                        % (ent.get("status") or ent.get("sched_status")))

        problems = []
        paused = e.get("paused") or []
        clients = e.get("clients") or []
        if True not in paused:
            problems.append("no viewer listed as paused (%s)" % paused)
        elif not (clients and clients[paused.index(True)]):
            problems.append("the paused viewer has no client named")
        if not [r for r in e.get("recordings") or [] if r <= 5]:
            problems.append("no recording listed live (%s)" % e.get("recordings"))
        if not [r for r in e.get("recorded") or []
                if abs(r[0] - start) <= 2 and abs(r[1] - stop) <= 2]:
            problems.append("no recorded span %d..%d (%s)" % (start, stop, e.get("recorded")))
        if rec_bytes <= 0:
            problems.append("no bytes counted for the recording")
        budget = ctx.jload("/status/caches").get("budget") or {}
        if "rec_ram" not in budget:
            problems.append("the budget does not count what recordings take")
        if rec_sub is None:
            problems.append("the recording's subscription is not listed")
        elif rec_sub.get("cache_role") != "recording" or rec_sub.get("cache") != e.get("uuid"):
            problems.append("the recording's subscription is %r of %s"
                            % (rec_sub.get("cache_role"), rec_sub.get("cache")))
        if me is None:
            problems.append("the client's subscription is not marked paused")

        detail = ("paused %s, clients %s, recordings %s, %.1f MB recorded"
                  % (paused, clients, e.get("recordings"), rec_bytes / 1e6))
        return (FAIL, "; ".join(problems) + " -- " + detail) if problems else (PASS, detail)
    finally:
        ctx.drop_entry(uuid)
        h.send(method="subscriptionSpeed", subscriptionId=sid, speed=100)
        ctx.skip(h, sid, 3600)
