"""Under "RAM only", the caches share the RAM budget evenly.

The RAM budget is shared by every channel's cache, and a cache that cannot
make room gives up its own oldest blocks, never another's.  So the cache that
filled the budget first would keep it -- typically a channel kept tuned after
its last viewer left -- and the one a viewer then opened would have a few
seconds of history, losing even those whenever an append found no room.

It needs a second channel (--second-channel) and no cache on the server, as
"RAM only" applies to the caches opened after it is set.  See sharing.py for
how it goes.
"""
from sharing import run_shared

NUMBER, TITLE = 31, "RAM only shares the RAM budget between caches"
NEEDS = ("hd", "hd2")


def run(ctx):
    return run_shared(ctx, "ram")
