"""Two caches sharing a budget, for checks 31 ("RAM only") and 32 (disk only).

The second channel's cache fills the budget alone and is left to the
keepalive with nobody watching; the channel's own must then reach most of
its share, an even split of the budget -- or of what its bitrate lets it
fill within the check -- and offer its viewer a window to match.  The room must
move gradually, as the newcomer fills it: ten seconds in, the first cache
must have given back little more than the newcomer holds, not half the
budget at once.  The budget is two minutes of the second channel's stream,
between 48 and 64 MB -- a small NAS has little RAM to spare for a high-
definition channel -- and the keepalive keeps a cache whatever it spans for
the length of the check.  Both caches must be opened under the settings of
the check, so it wants a server with no cache yet; the settings are put
back afterwards.
"""
import math
import time

from common import Ctx, PASS, FAIL, ABSENT
import htsp as H

SID_FIRST, SID_SECOND = 87, 88
MIB = 1 << 20

# per mode: the settings that make it, what a cache holds of the budget,
# and the budget's used and maximum
MODES = {
    "ram": dict(name="\"RAM only\"", held="ram", used="ram_used", max="ram_max"),
    "disk": dict(name="disk only", held="size", used="size_used", max="size_max"),
}


def _caches(ctx, sub):
    """The caches of the channel and of the second one, as entries or None."""
    mine = set(ctx.services or [ctx.service])
    theirs = set(sub.services or [sub.service])
    a = b = None
    for e in ctx.jload("/status/caches").get("entries", []):
        if e.get("uuid") in mine:
            a = e
        elif e.get("uuid") in theirs:
            b = e
    return a, b


def _close(h, sid):
    if h is None:
        return
    try:
        h.send(method="unsubscribe", subscriptionId=sid)
        Ctx.pump(h, 2)
        h.s.close()
    except Exception:
        pass


def _budget(ctx, mode, mb):
    """Set the mode, with a budget of mb MB."""
    if mode == "ram":
        ctx.timeshift(ram_only=True, ram_size=mb)
    else:
        ctx.timeshift(ram_only=False, ram_size=0, unlimited_size=False, max_size=mb)


def _held(e, mode):
    if not e:
        return 0
    return e.get("ram", 0) + e.get("staging", 0) if mode == "ram" else e.get("size", 0)


def run_shared(ctx, mode):
    m = MODES[mode]
    name = getattr(ctx, "second_channel", None)
    if not name:
        return ABSENT, "name another channel with --second-channel"
    if name == ctx.channel_name:
        return ABSENT, "--second-channel names the channel under test"
    busy = ctx.server_in_use()
    if busy:
        return (ABSENT, "%s; this check shrinks the "
                        "shared budget" % busy)
    ctx.drop_warm()
    listed = ctx.jload("/status/caches").get("entries", [])
    if listed:
        return (ABSENT, "caches from before %s is set would keep theirs (%s); run "
                        "this check first, or once they have expired"
                % (m["name"], ", ".join(str(e.get("channel") or e.get("service"))
                                       for e in listed)))
    sub = Ctx(ctx.host, ctx.user, ctx.password, name, http=ctx.http,
              htsp=ctx.htsp_port, ssh_target=ctx.ssh_target,
              log_path=ctx.log_path).resolve()

    before = ctx.timeshift()
    if not before.get("cache_keepalive"):
        return ABSENT, "the cache keepalive is off: nothing keeps the first cache"
    h1 = h2 = None
    try:
        mb = 48
        ctx.timeshift(cache_keepalive_min_period=0)
        _budget(ctx, mode, mb)

        # the second channel's cache, alone, until it fills the budget
        h1 = sub.connect()
        H._subscribe(h1, SID_FIRST, sub.chan_id)
        ctx.pump(h1, 20)
        _, b = _caches(ctx, sub)
        if b is None:
            return FAIL, "no cache for %s after 20 s" % name
        rate = b.get("size", 0) / b["span"] if b.get("span", 0) > 5 else 0
        mb = max(48, min(64, int(math.ceil(rate * 120 / MIB))))
        _budget(ctx, mode, mb)
        full = False
        end = time.time() + 240
        while time.time() < end and not full:
            ctx.pump(h1, 5)
            budget = ctx.jload("/status/caches").get("budget") or {}
            full = budget.get(m["used"], 0) >= 0.9 * budget.get(m["max"], 1)
        if not full:
            return FAIL, "the first cache did not fill a %d MB budget in 240 s" % mb
        _close(h1, SID_FIRST)
        h1 = None
        time.sleep(3)
        _, b = _caches(ctx, sub)
        if b is None:
            return ABSENT, "the first cache went with its viewer: no keepalive held it"

        # then a viewer on the channel's own
        b0 = _held(b, mode)
        h2 = ctx.connect()
        H._subscribe(h2, SID_SECOND, ctx.chan_id)
        t2 = time.time()
        ctx.pump(h2, 10)
        a, b = _caches(ctx, sub)
        budget = ctx.jload("/status/caches").get("budget") or {}
        given, taken = b0 - _held(b, mode), _held(a, mode)
        gradual = given <= taken + 0.05 * budget.get(m["max"], 0) + 5e6
        a = None
        window = 0
        share = 0
        end = time.time() + 180
        while time.time() < end:
            st = ctx.pump(h2, 10) or {}
            window = (st.get("end", 0) - st.get("start", 0)) / 1e6
            d = ctx.jload("/status/caches")
            n = max(1, len(d.get("entries", [])))
            share = (d.get("budget") or {}).get(m["max"], 0) / n
            a, b = _caches(ctx, sub)
            if _held(a, mode) >= 0.8 * share:
                break

        if a is None:
            return (ABSENT, "no cache for %s after 190 s: the channel gave no data "
                            "(see the server log)" % ctx.channel_name)
        # what the newcomer could have taken by now, at its own bitrate: a
        # slow channel does not fill its share within the check
        rate_a = a.get("size", 0) / a["span"] if a.get("span", 0) > 5 else 0
        elapsed = time.time() - t2
        room = min(share, rate_a * elapsed) if rate_a else share
        ok = (gradual and _held(a, mode) >= 0.6 * room
              and window >= 0.4 * (room / rate_a if rate_a else 0))
        return (PASS if ok else FAIL,
                "after 10 s %s had given %.0f MB for %.0f MB taken%s; then %s %.0f MB "
                "(kept, nobody watching), %s %.0f MB with a %.0f s window; share %.0f MB "
                "of %d MB" % (name, given / 1e6, taken / 1e6,
                              "" if gradual else " (too much at once)",
                              name, _held(b, mode) / 1e6, ctx.channel_name,
                              _held(a, mode) / 1e6, window, share / 1e6, mb))
    finally:
        _close(h1, SID_FIRST)
        _close(h2, SID_SECOND)
        # max_size too: with "RAM only" set, timeshift_fixup() overwrites it
        # with the RAM size, and turning the option off does not put it back
        ctx.timeshift(ram_only=before.get("ram_only"),
                      ram_size=before.get("ram_size"),
                      max_size=before.get("max_size"),
                      unlimited_size=before.get("unlimited_size"),
                      cache_keepalive_min_period=before.get("cache_keepalive_min_period"))
