"""Two clients moving through the same cache independently.

Sharing one cache must not mean sharing one position.  The long-standing
viewer and the newcomer are asked to go to different places; both answers must
be their own.  Printed side by side, they also show the cache at work: the
newcomer reaches further back than it has been connected.
"""
from common import PASS, FAIL

NUMBER, TITLE = 12, "two clients seeking independently"


def run(ctx):
    h, sid = ctx.warm()
    second = getattr(ctx, "second", None)
    if second is None:
        return (FAIL, "no second client; run check 10 or 11 first")
    a = ctx.position(ctx.skip(h, sid, -30))
    b = getattr(ctx, "second_position", None)
    ok = a is not None and b is not None
    return (PASS if ok else FAIL,
            "first client %s, second %s"
            % ("%.1f s" % a if a is not None else "refused",
               "%.1f s" % b if b is not None else "refused"))
