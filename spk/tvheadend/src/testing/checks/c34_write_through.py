"""With RAM and a disk, the cache is on disk whole and its newest part in RAM.

A cache that has a disk writes everything to it, and keeps a RAM copy of
its newest blocks within the RAM budget: pausing and rewinding a little --
what a viewer does most -- read from memory, and giving up a copy loses
nothing.  Before, the RAM held the oldest part of the cache, the data kept
when it was opened and never moved, and only what came after went to disk.

With 8 MB of RAM and a viewer on the channel until the cache outgrows it
-- up to three minutes, as a channel of a low bitrate takes a while -- the
cache status must show the newest part in RAM and the oldest on disk, RAM
no larger than its budget, the disk holding the whole cache but for what still
waits to be written, and a rewind of a few seconds -- into the RAM part --
must be answered and followed by packets.  The settings are put back.
"""
import time

from common import PASS, FAIL, ABSENT
import htsp as H

NUMBER, TITLE = 34, "with a disk, the newest part of a cache is in RAM"
SID = 90
RAM, STAGING, DISK = 1, 2, 3
SETTINGS = ("ram_only", "ram_size", "max_size", "unlimited_size")


def run(ctx):
    if "entries" not in ctx.jload("/status/caches"):
        return ABSENT, "this build has no api/status/caches"
    busy = ctx.server_in_use()
    if busy:
        return (ABSENT, "%s; this check changes the "
                        "timeshift settings" % busy)
    before = ctx.timeshift()
    h = None
    try:
        ctx.timeshift(ram_only=False, ram_size=8, unlimited_size=False, max_size=4096)
        h = ctx.connect()
        H._subscribe(h, SID, ctx.chan_id)
        end = time.time() + 180
        ctx.pump(h, 30)
        e = ctx.cache_entry() or {}
        while not e.get("disk_only", e.get("disk")) and time.time() < end:
            ctx.pump(h, 10)
            e = ctx.cache_entry() or {}
        # gaps aside, and the newest blocks still on their way to the disk
        m = [x for x in (e.get("map") or []) if x and x != STAGING]
        budget = ctx.jload("/status/caches").get("budget") or {}
        where = "RAM %.1f, waiting %.1f, disk %.1f MB" % (
            e.get("ram", 0) / 1e6, e.get("staging", 0) / 1e6, e.get("disk", 0) / 1e6)
        problems = []
        if not m:
            return FAIL, "no cache to look at (%s)" % where
        if m[-1] != RAM:
            problems.append("the newest data is not in RAM")
        if m[0] != DISK:
            problems.append("the oldest data is not on disk")
        if budget.get("ram_used", 0) > budget.get("ram_max", 0):
            problems.append("RAM over its budget")
        # the disk holds the whole cache, RAM copies included, but for what
        # still waits to be written
        if "disk_only" in e and e.get("disk", 0) < 0.95 * (e.get("size", 0) - e.get("staging", 0)):
            problems.append("the disk does not hold the whole cache")
        r = ctx.skip(h, SID, seconds=-3)
        landed = ctx.position(r)
        got = 0
        end = time.time() + 5
        while time.time() < end:
            msg = h.recv(2)
            if msg and msg.get("method") == "muxpkt":
                got += 1
        if landed is None or got == 0:
            problems.append("a rewind into the RAM part was not served")
        detail = "%s; a 3 s rewind %s, %d packets after" % (
            where, "landed" if landed is not None else "refused", got)
        return (FAIL, "; ".join(problems) + " -- " + detail) if problems else (PASS, detail)
    finally:
        if h is not None:
            try:
                h.send(method="unsubscribe", subscriptionId=SID)
                ctx.pump(h, 2)
                h.s.close()
            except Exception:
                pass
        ctx.timeshift(**{k: before.get(k) for k in SETTINGS})
