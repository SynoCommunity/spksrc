"""With no RAM budget, the caches share the timeshift size evenly.

Every channel's cache draws on one size budget, and a cache that cannot make
room gives up its own oldest blocks, never another's: on a small disk budget
the cache that filled it first would keep it, and the next one would start
a fresh timeline every second.  The check sets the RAM budget to nothing, so
that the caches live on disk, and a size budget of two minutes of the second
channel's stream.

It needs a second channel (--second-channel) and no cache on the server.
See sharing.py for how it goes.
"""
from sharing import run_shared

NUMBER, TITLE = 32, "with no RAM, the caches share the size budget"
NEEDS = ("hd", "hd2")


def run(ctx):
    return run_shared(ctx, "disk")
