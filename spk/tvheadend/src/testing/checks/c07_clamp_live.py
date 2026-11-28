"""Asking to go past live.

The mirror of the previous one: a client that asks to jump forward beyond the
present must land at live.  A server that lets the position run past live
would be asking its reader for packets that do not exist yet.
"""
from common import PASS, FAIL

NUMBER, TITLE = 7, "fast-forward past live clamps"


def run(ctx):
    h, sid = ctx.warm()
    p = ctx.position(ctx.skip(h, sid, 9999))
    ctx.last_position = p
    return (PASS if p is not None else FAIL,
            "clamped to %.1f s" % p if p is not None else "answered SMT_SKIP_ERROR")
