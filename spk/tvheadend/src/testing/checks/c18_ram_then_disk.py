"""What happens when the RAM budget fills.

A cache block is allocated at its full size and sealed after a second whether
it is full or not, so on a quiet channel the RAM budget is reached long before
the logical one.  What the cache does then decides whether it keeps a rolling
history or loses all of it: evicting the oldest block keeps the window moving,
while declaring a gap throws the lot away.

Under "RAM only" there is nowhere else to put the payload, so this is where it
shows.  The budget is lowered for the check and put back afterwards: to 24 MB,
or to a minute of the channel's stream if that is more, up to 64 MB, so that a
high bitrate still leaves a window worth measuring on a NAS with little RAM.  The window is measured four times, and
must stay open rather than collapse.

The RAM budget is shared, and a cache that cannot make room gives up its own
oldest block, not another cache's: another channel's cache that already holds
the budget leaves this one a few seconds.  The check measures one cache, so it
is absent while another channel's is held.
"""
import math

from common import PASS, FAIL, ABSENT
import htsp as H

NUMBER, TITLE = 18, "RAM-only cache rolls instead of collapsing"


def run(ctx):
    busy = ctx.server_in_use()
    if busy:
        return (ABSENT, "%s; this check shrinks the "
                        "shared budget" % busy)
    others = [e.get("channel") or e.get("service")
              for e in ctx.jload("/status/caches").get("entries", [])
              if e.get("uuid") not in set(ctx.services or [ctx.service])]
    if others:
        return (ABSENT, "another channel's cache shares the RAM budget (%s)"
                        % ", ".join(str(o) for o in others))
    # a minute of the stream, from the channel's own cache
    ctx.warm()
    e = ctx.cache_entry() or {}
    rate = e.get("size", 0) / e["span"] if e.get("span", 0) > 10 else 0
    ram = max(24, min(64, int(math.ceil(rate * 60 / (1 << 20)))))
    before = ctx.timeshift()
    try:
        ctx.timeshift(ram_only=True, ram_size=ram)
        h = ctx.connect()
        H._subscribe(h, 81, ctx.chan_id)
        spans = []
        for _ in range(4):
            st = ctx.pump(h, 45) or {}
            spans.append((st.get("end", 0) - st.get("start", 0)) / 1e6)
        try:
            h.send(method="unsubscribe", subscriptionId=81)
            h.s.close()
        except Exception:
            pass
        kept = all(s > 10 for s in spans) and spans[-1] >= spans[1] * 0.5
        return (PASS if kept else FAIL,
                "window: " + ", ".join("%.0fs" % s for s in spans)
                + " in %d MB" % ram)
    finally:
        # max_size too: with "RAM only" set, timeshift_fixup() overwrites it
        # with the RAM size, and turning the option off does not put it back
        ctx.timeshift(ram_only=before.get("ram_only"),
                      ram_size=before.get("ram_size"),
                      max_size=before.get("max_size"))
