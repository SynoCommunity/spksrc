"""Where a viewer is put back when they return to a recording.

A recording fed by the cache starts where the cache reached, which can be
before the programme was due to begin.  A viewer who leaves half an hour in has
a place in that file worth keeping -- but measured against the scheduled start
it looks like a position before the recording existed, and is thrown away.

The position is written when the viewer leaves: htsp_cache_record_position()
runs from the subscription being torn down, nowhere else.  So the check parks a
viewer behind the scheduled start, disconnects, and only then reads the entry.
"""
from common import PASS, FAIL
import htsp as H
import time

NUMBER, TITLE = 22, "resume position before the scheduled start"


def run(ctx):
    h = ctx.connect()
    u = None
    try:
        H._subscribe(h, 83, ctx.chan_id)
        ctx.pump(h, 95)
        now = int(ctx.now())
        u = ctx.create_entry(start=now + 10, stop=now + 240,
                             title={"eng": "resume check"}, __cache_full=1)
        ctx.pump(h, 50)
        ctx.skip(h, 83, -70)
        ctx.pump(h, 20)
        try:
            h.send(method="unsubscribe", subscriptionId=83)
            ctx.pump(h, 4)
            h.s.close()
        except Exception:
            pass
        h = None
        time.sleep(4)
        pos = ctx.entry(u).get("playposition")
        return (PASS if (pos or 0) > 0 else FAIL,
                "playposition %r" % (pos,))
    finally:
        if h is not None:
            try:
                h.send(method="unsubscribe", subscriptionId=83)
                h.s.close()
            except Exception:
                pass
        ctx.drop_entry(u)
