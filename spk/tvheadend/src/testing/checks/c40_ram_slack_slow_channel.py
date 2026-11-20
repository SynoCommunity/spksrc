"""A slow channel's RAM share holds its data, not its blocks' slack.

The RAM budget charges what malloc() takes.  A cache appends into 256 KiB
blocks, sealed when full or a second old, so a standard-definition channel's
-- around 0.2 MB/s -- fills each to two thirds: its even share of the RAM
held a third of empty allocation, and Status > Timeshift showed it holding
less than the others, though it had the same share.  A sealed block's
allocation is now brought down to its data.

With a viewer on the channel for a minute, the cache's RAM data must be at
least nine tenths of what that RAM is charged (`ram_charged`).  It wants a
slow channel (--channel), a RAM budget, and the settings as they are: it
changes none.
"""
import time

from common import PASS, FAIL, ABSENT
import htsp as H

NUMBER, TITLE = 40, "a slow channel's RAM share holds its data"
NEEDS = ("sd",)
SID = 93


def run(ctx):
    if "entries" not in ctx.jload("/status/caches"):
        return ABSENT, "this build has no api/status/caches"
    conf = ctx.timeshift()
    if not conf.get("ram_size") or conf.get("ram_only"):
        return ABSENT, "it wants RAM copies in front of the disk: a RAM budget, not RAM only"
    h = None
    try:
        h = ctx.connect()
        H._subscribe(h, SID, ctx.chan_id)
        e = {}
        end = time.time() + 120
        ctx.pump(h, 45)
        while time.time() < end:
            e = ctx.cache_entry() or {}
            if e.get("ram_charged", 0) > 2e6:
                break
            ctx.pump(h, 5)
        if "ram_charged" not in e:
            return (ABSENT if e else FAIL,
                    "this build does not report a cache's charged RAM" if e
                    else "no cache for %s" % ctx.channel_name)
        rate = e.get("size", 0) / e["span"] if e.get("span", 0) > 5 else 0
        if rate > 0.6e6:
            return (ABSENT, "%s is not a slow channel (%.2f MB/s): its blocks fill before they "
                            "are sealed; name a standard-definition one" % (ctx.channel_name, rate / 1e6))
        data, charged = e.get("ram", 0), e.get("ram_charged", 0)
        if charged <= 0:
            return FAIL, "the cache holds no RAM after two minutes"
        ratio = data / charged
        return (PASS if ratio >= 0.9 else FAIL,
                "%s at %.2f MB/s: %.1f MB of data in RAM for %.1f MB charged (%.0f%%)"
                % (ctx.channel_name, rate / 1e6, data / 1e6, charged / 1e6, 100 * ratio))
    finally:
        if h is not None:
            try:
                h.send(method="unsubscribe", subscriptionId=SID)
                ctx.pump(h, 2)
                h.s.close()
            except Exception:
                pass
