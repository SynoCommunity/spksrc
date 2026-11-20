"""Rewinding twice in a row.

A second rewind must start from where the first one landed, not from live.  If
the server loses the client's position between skips, the second one lands at
the same place as the first -- or fails outright.
"""
from common import PASS, FAIL

NUMBER, TITLE = 4, "a second, cumulative rewind"


def run(ctx):
    h, sid = ctx.warm()
    before = getattr(ctx, "last_position", None)
    p = ctx.position(ctx.skip(h, sid, -30))
    ctx.last_position = p
    ok = p is not None and (before is None or p < before)
    return (PASS if ok else FAIL,
            "landed at %.1f s" % p if p is not None else "answered SMT_SKIP_ERROR")
