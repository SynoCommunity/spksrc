"""Reaching history captured before the client arrived.

This is what separates a per-channel cache from a per-client buffer, and it is
the single most telling check in the set.  A client that subscribed fourteen
seconds ago asks to go back a minute.  With a buffer of its own it cannot: it
lands about a second in, because that is all it has.  With a cache belonging to
the channel it reaches material recorded before it was there at all.

The setting is "Cache seek before tune-in"; with it off the range is clamped to
the client's own zero, which is what check 20 exercises.
"""
from common import PASS, FAIL

NUMBER, TITLE = 11, "seek before the client's own tune-in"


def run(ctx):
    second = getattr(ctx, "second", None)
    if second is None:
        import htsp as H
        second = ctx.connect()
        H._subscribe(second, 62, ctx.chan_id)
        ctx.pump(second, 14)
        ctx.second, ctx.second_sid = second, 62
    p = ctx.position(ctx.skip(second, ctx.second_sid, -60))
    ctx.second_position = p
    deep = p is not None and p < -20
    return (PASS if deep else FAIL,
            "a client 14 s old reached %.1f s" % p if p is not None
            else "answered SMT_SKIP_ERROR")
