"""The caches' RAM goes back to the system when they close.

A cache's blocks are brought down to what they hold once sealed, so they
end up of every size.  In the heap, the tails given back would be holes
between blocks still in use, kept from merging by the small allocations
that settle in them -- fragmentation, and memory the process keeps.  The
blocks' data therefore lives in pages of its own, mapped and unmapped.

With a RAM budget of 64 MB, a fast channel's cache and a slow one's
(--second-channel) fill it for a minute; then both close.  Of the resident
memory the tvheadend process gained, at least three quarters must be gone ten
seconds later.  It reads the process's memory over ssh, wants a server
nobody else is using, as it turns the shared cache off and on, and puts the
settings back.
"""
import time

from common import PASS, FAIL, ABSENT, Ctx
import htsp as H

NUMBER, TITLE = 41, "the caches' RAM goes back to the system"
NEEDS = ("hd", "sd")
NEEDS_LOG = True
SID_FAST, SID_SLOW = 94, 95
SETTINGS = ("ram_only", "ram_size", "max_size", "unlimited_size", "record_cache")
RSS = ("for p in /proc/[0-9]*; do grep -qx 'Name:[[:space:]]*tvheadend' $p/status 2>/dev/null "
       "&& awk '/^VmRSS/ {print $2}' $p/status; done | head -1")


def _rss(ctx):
    out = ctx.log(RSS)
    return int(out) * 1024 if out.isdigit() else None


def _close(h, sid):
    if h is None:
        return
    try:
        h.send(method="unsubscribe", subscriptionId=sid)
        time.sleep(1)
        h.s.close()
    except Exception:
        pass


def run(ctx):
    if not (ctx.ssh_target and ctx.log_path):
        return ABSENT, "needs --ssh and --log to read the server's memory"
    name = getattr(ctx, "second_channel", None)
    if not name:
        return ABSENT, "name a slow channel with --second-channel"
    busy = ctx.server_in_use()
    if busy:
        return ABSENT, "%s; this check turns the shared cache off and on" % busy
    ctx.drop_warm()
    if _rss(ctx) is None:
        return ABSENT, "could not read the tvheadend process's memory"
    slow = Ctx(ctx.host, ctx.user, ctx.password, name, http=ctx.http, htsp=ctx.htsp_port,
               ssh_target=ctx.ssh_target, log_path=ctx.log_path).resolve()
    before = ctx.timeshift()
    hf = hs = None
    try:
        ctx.timeshift(record_cache=False)
        time.sleep(8)
        ctx.timeshift(record_cache=True, ram_only=False, ram_size=64,
                      unlimited_size=False, max_size=4096)
        time.sleep(3)
        r0 = _rss(ctx)
        hf, hs = ctx.connect(), slow.connect()
        H._subscribe(hf, SID_FAST, ctx.chan_id)
        H._subscribe(hs, SID_SLOW, slow.chan_id)
        end = time.time() + 60
        while time.time() < end:
            ctx.pump(hf, 2)
            slow.pump(hs, 1)
        budget = ctx.jload("/status/caches").get("budget") or {}
        r1 = _rss(ctx)
        _close(hf, SID_FAST)
        _close(hs, SID_SLOW)
        hf = hs = None
        ctx.timeshift(record_cache=False)
        time.sleep(10)
        r2 = _rss(ctx)
    finally:
        _close(hf, SID_FAST)
        _close(hs, SID_SLOW)
        ctx.timeshift(**{k: before.get(k) for k in SETTINGS if k in before})

    if None in (r0, r1, r2):
        return ABSENT, "could not read the tvheadend process's memory"
    gained, back = r1 - r0, r1 - r2
    if gained < 30e6:
        return (ABSENT, "the caches took too little memory to tell (%.1f MB, RAM budget %.0f of "
                        "%.0f MB used)" % (gained / 1e6, budget.get("ram_used", 0) / 1e6,
                                         budget.get("ram_max", 0) / 1e6))
    return (PASS if back >= 0.75 * gained else FAIL,
            "the process gained %.1f MB with the caches, %.1f MB of it back 10 s after they "
            "closed (%.0f%%)" % (gained / 1e6, back / 1e6, 100 * back / gained))
