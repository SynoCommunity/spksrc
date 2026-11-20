"""RAM copies shared between a fast cache and a slow one.

With RAM and a disk, a cache keeps a RAM copy of its newest blocks within
its share of the RAM budget.  A cache under its share that is short of RAM
asks for some, and the caches over theirs give it back.  Before, nothing
kept the room given back for the cache that asked: a high-definition
cache, which reserves a copy ten times as often as a standard-definition
one, took it again at once and even grew past its share, while the slow
cache, short of RAM each time its own block came, gave up its own oldest
copy instead and never grew -- seen as a paused SD channel holding 16 MB
of RAM for a 128 MB share while an HD one held 218.

The share is max-min fair: a cache that needs less than an even split
leaves the rest to the others.  With 64 MB of RAM: the faster of the two
channels fills the RAM alone, then a viewer joins the slower one and
pauses after 30 s.  Within four minutes the slow cache must hold in RAM
most of what it could -- all it has written, up to an even split -- and
the fast one no more than the rest.  The two channels must differ in bitrate threefold at least:
name a standard-definition one with --second-channel.  It wants a server
with no cache yet, and puts the settings back.
"""
import time

from common import Ctx, PASS, FAIL, ABSENT
import htsp as H
from sharing import _caches, _close

NUMBER, TITLE = 38, "RAM copies shared between a fast cache and a slow one"
NEEDS = ("hd", "sd")
SID_FAST, SID_SLOW = 93, 94
RAM_MB = 64
SETTINGS = ("ram_only", "ram_size", "max_size", "unlimited_size", "cache_keepalive_min_period")


def _rate(ctx, other):
    """Bytes per second of the channel's stream and of the other's, over 15 s each."""
    out = []
    for c in (ctx, other):
        h = c.connect()
        H._subscribe(h, 99, c.chan_id)
        got, end = 0, time.time() + 15
        while time.time() < end:
            m = h.recv(1)
            if m and m.get("method") == "muxpkt":
                got += len(m.get("payload") or b"")
        _close(h, 99)
        out.append(got / 15.0)
    return out


def run(ctx):
    name = getattr(ctx, "second_channel", None)
    if not name or name == ctx.channel_name:
        return ABSENT, "name a channel of another bitrate with --second-channel"
    busy = ctx.server_in_use()
    if busy:
        return ABSENT, "%s; this check changes the RAM budget" % busy
    ctx.drop_warm()
    listed = ctx.jload("/status/caches").get("entries", [])
    if listed:
        return (ABSENT, "caches from before would count towards the shares (%s); run this "
                        "check first, or once they have expired"
                % ", ".join(str(e.get("channel") or e.get("service")) for e in listed))
    other = Ctx(ctx.host, ctx.user, ctx.password, name, http=ctx.http,
                htsp=ctx.htsp_port, ssh_target=ctx.ssh_target,
                log_path=ctx.log_path).resolve()
    r_ctx, r_other = _rate(ctx, other)
    if min(r_ctx, r_other) <= 0:
        return ABSENT, "a channel gave no data (%.2f and %.2f MB/s)" % (r_ctx / 1e6, r_other / 1e6)
    if max(r_ctx, r_other) < 3 * min(r_ctx, r_other):
        return (ABSENT, "the channels' bitrates are alike (%.2f and %.2f MB/s): name a "
                        "standard-definition one with --second-channel" % (r_ctx / 1e6, r_other / 1e6))
    fast, slow = (ctx, other) if r_ctx > r_other else (other, ctx)
    before = ctx.timeshift()
    hf = hs = None
    try:
        ctx.timeshift(ram_only=False, ram_size=RAM_MB, unlimited_size=False, max_size=4096,
                      cache_keepalive_min_period=0)
        time.sleep(3)
        # the fast cache, alone, until the RAM is full
        hf = fast.connect()
        H._subscribe(hf, SID_FAST, fast.chan_id)
        full, end = False, time.time() + 120
        while time.time() < end and not full:
            Ctx.pump(hf, 5)
            b = ctx.jload("/status/caches").get("budget") or {}
            full = b.get("ram_used", 0) >= 0.9 * b.get("ram_max", 1)
        if not full:
            return FAIL, "the fast cache did not fill %d MB of RAM in 120 s" % RAM_MB
        # then a viewer on the slow one, paused after 30 s
        hs = slow.connect()
        H._subscribe(hs, SID_SLOW, slow.chan_id)
        t0, paused, ok = time.time(), False, False
        f = s = None
        share = RAM_MB * 1e6
        while time.time() - t0 < 240:
            Ctx.pump(hs, 5)
            Ctx.pump(hf, 1)
            if not paused and time.time() - t0 > 30:
                hs.send(method="subscriptionSpeed", subscriptionId=SID_SLOW, speed=0)
                paused = True
            d = ctx.jload("/status/caches")
            share = (d.get("budget") or {}).get("ram_max", 0) / max(1, len(d.get("entries", [])))
            f, _ = _caches(fast, slow)
            s, _ = _caches(slow, fast)
            if f and s and time.time() - t0 > 60:
                room = min(share, s.get("size", 0) - s.get("staging", 0))
                rest = RAM_MB * 1048576 - s.get("ram", 0)
                ok = (s.get("ram", 0) >= 0.7 * room
                      and f.get("ram", 0) <= rest + 4 * 1048576)
                if ok:
                    break
        if not (f and s):
            return FAIL, "a cache went: %s %s" % (fast.channel_name if not f else "", slow.channel_name if not s else "")
        detail = ("%s (%.2f MB/s) %.1f MB of RAM, %s (%.2f MB/s, paused) %.1f MB for %.1f MB "
                  "written; even split %.1f MB, after %.0f s" % (
                      fast.channel_name, max(r_ctx, r_other) / 1e6, f.get("ram", 0) / 1e6,
                      slow.channel_name, min(r_ctx, r_other) / 1e6, s.get("ram", 0) / 1e6,
                      (s.get("size", 0) - s.get("staging", 0)) / 1e6, share / 1e6,
                      time.time() - t0))
        return (PASS, detail) if ok else (FAIL, "the slow cache did not get its share -- " + detail)
    finally:
        _close(hs, SID_SLOW)
        _close(hf, SID_FAST)
        ctx.timeshift(**{k: before.get(k) for k in SETTINGS})
