"""Going back by a given amount.

The ordinary rewind: ask to move 45 seconds earlier and land there.  The server
answers `subscriptionSkip` with the position it reached, or with an error.  On
a build with the cache this is served from the channel's cache; without it,
from the client's own buffer.  Both should manage it.
"""
from common import PASS, FAIL

NUMBER, TITLE = 3, "rewind 45 s"


def run(ctx):
    h, sid = ctx.warm()
    p = ctx.position(ctx.skip(h, sid, -45))
    ctx.last_position = p
    return (PASS if p is not None else FAIL,
            "landed at %.1f s" % p if p is not None else "answered SMT_SKIP_ERROR")
