"""Changing where the caches live, while a cache is in use.

The timeshift settings are applied to the caches already open, not only to
the next ones: a cache follows "RAM only" being turned on or off and the RAM
budget being lowered, and turning the shared cache off lets go of the
channels kept tuned for it.  Before, a cache kept the mode it was opened in
-- writing to disk under "RAM only" until it was closed -- and its RAM blocks
stayed in RAM under a budget lowered to nothing.

With a viewer on the channel, the check goes through RAM then disk (with 4 MB
of RAM, so that data reaches the disk), "RAM only" (nothing may stay on
disk), no RAM (what was in RAM moves to disk), RAM then disk again, then lets
the viewer go so that the keepalive holds the cache, and turns the shared
cache off: the keepalive must go, and the cache with it.  At each step the
cache status must say what the settings say.  Everything is put back.
"""
import time

from common import PASS, FAIL, ABSENT
import htsp as H

NUMBER, TITLE = 33, "the caches follow the settings as they change"
SID = 89
SETTINGS = ("enabled", "record_cache", "ram_only", "ram_size", "max_size", "unlimited_size",
            "cache_keepalive_min_period")


def _wait(ctx, h, seconds, test):
    """Pump until test(entry, budget) holds, up to `seconds`; the last
    entry and budget seen, and whether it held."""
    end = time.time() + seconds
    e = b = None
    while True:
        if h is not None:
            ctx.pump(h, 3)
        else:
            time.sleep(3)
        d = ctx.jload("/status/caches")
        b = d.get("budget") or {}
        e = ctx.cache_entry()
        if test(e or {}, b):
            return e, b, True
        if time.time() >= end:
            return e, b, False


def _where(e):
    e = e or {}
    return "RAM %.1f, waiting %.1f, disk %.1f MB" % (
        e.get("ram", 0) / 1e6, e.get("staging", 0) / 1e6, e.get("disk", 0) / 1e6)


def run(ctx):
    if "entries" not in ctx.jload("/status/caches"):
        return ABSENT, "this build has no api/status/caches"
    busy = ctx.server_in_use()
    if busy:
        return (ABSENT, "%s; this check changes the "
                        "timeshift settings" % busy)
    ctx.drop_warm()
    before = ctx.timeshift()
    if not before.get("cache_keepalive"):
        return ABSENT, "the cache keepalive is off: the last step needs it"
    steps = []
    problems = []
    h = None

    def step(name, ok, e):
        steps.append("%s: %s" % (name, _where(e)))
        if not ok:
            problems.append(name)

    try:
        # no minimum history for the keepalive: the last step needs one
        ctx.timeshift(enabled=True, record_cache=True, ram_only=False, ram_size=4,
                      unlimited_size=False, max_size=4096, cache_keepalive_min_period=0)
        h = ctx.connect()
        H._subscribe(h, SID, ctx.chan_id)

        e, b, ok = _wait(ctx, h, 120, lambda e, b: e.get("disk", 0) > 0)
        step("RAM then disk", ok and not e.get("ram_only"), e)

        ctx.timeshift(ram_only=True, ram_size=48)
        e, b, ok = _wait(ctx, h, 30, lambda e, b: e.get("ram_only") and b.get("ram_only")
                         and e.get("disk", 1) == 0 and e.get("staging", 1) == 0
                         and e.get("ram", 0) > 0)
        step("RAM only", ok, e)

        ctx.timeshift(ram_only=False, ram_size=0, max_size=4096)
        e, b, ok = _wait(ctx, h, 60, lambda e, b: not e.get("ram_only")
                         and b.get("ram_max", 1) == 0 and e.get("ram", 1) == 0
                         and e.get("disk", 0) > 0)
        step("no RAM", ok, e)

        ctx.timeshift(ram_size=16)
        e, b, ok = _wait(ctx, h, 30, lambda e, b: e.get("ram", 0) > 0 and b.get("ram_max", 0) > 0)
        step("RAM then disk again", ok, e)

        # the viewer goes: the keepalive holds the cache, then the cache is
        # turned off and both must go
        h.send(method="unsubscribe", subscriptionId=SID)
        ctx.pump(h, 2)
        h.s.close()
        h = None
        e, b, kept = _wait(ctx, None, 10, lambda e, b: bool(e.get("keepalive")))
        ctx.timeshift(record_cache=False)
        e, b, ok = _wait(ctx, None, 15, lambda e, b: not e and not b.get("enabled", True))
        steps.append("kept, then turned off: %s" % (
            "the keepalive and the cache went" if ok else "the cache stayed (%s)" % _where(e)))
        if not kept:
            problems.append("no keepalive took the cache over")
        if not ok:
            problems.append("turned off")

        detail = "; ".join(steps)
        if problems:
            return FAIL, "did not follow: %s -- %s" % (", ".join(problems), detail)
        return PASS, detail
    finally:
        if h is not None:
            try:
                h.send(method="unsubscribe", subscriptionId=SID)
                ctx.pump(h, 2)
                h.s.close()
            except Exception:
                pass
        ctx.timeshift(**{k: before.get(k) for k in SETTINGS})
