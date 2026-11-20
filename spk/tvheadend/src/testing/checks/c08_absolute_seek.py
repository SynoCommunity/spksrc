"""Seeking to a position rather than by an amount.

`subscriptionSkip` with `absolute` set names a point on the timeline instead of
a distance from where the client is.  This is what a scrub bar sends, and it
takes a different path through the server from a relative skip.
"""
from common import PASS, FAIL

NUMBER, TITLE = 8, "absolute seek"


def run(ctx):
    h, sid = ctx.warm()
    st = ctx.pump(h, 4) or {}
    middle = int((st.get("start", 0) + st.get("end", 0)) / 2)
    p = ctx.position(ctx.skip(h, sid, absolute=middle))
    ctx.last_position = p
    return (PASS if p is not None else FAIL,
            "landed at %.1f s" % p if p is not None else "answered SMT_SKIP_ERROR")
