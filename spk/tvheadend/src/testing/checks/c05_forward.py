"""Going forward again.

From a rewound position, ask to move 20 seconds later.  The position must
advance; a server that treats every skip as absolute, or that only knows how
to go back, fails here.
"""
from common import PASS, FAIL

NUMBER, TITLE = 5, "fast-forward 20 s"


def run(ctx):
    h, sid = ctx.warm()
    before = getattr(ctx, "last_position", None)
    p = ctx.position(ctx.skip(h, sid, 20))
    ctx.last_position = p
    ok = p is not None and (before is None or p > before)
    return (PASS if ok else FAIL,
            "landed at %.1f s" % p if p is not None else "answered SMT_SKIP_ERROR")
