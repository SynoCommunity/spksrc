"""A cache that hit a full disk goes back to it once there is room again.

The channel cache writes everything to disk.  When a write fails -- the
volume full, which is where recordings land too -- new data stays off the
disk, in RAM while the RAM budget has room.  It used to stay off for the life
of the cache: a channel kept tuned, or watched for hours, lost its disk
history until it was tuned anew, even once the space had been freed.  Now
the cache tries the disk again every 30 s, on a new segment, and writes out
what it kept in RAM meanwhile.

The check mounts a small tmpfs on the server (over ssh, with sudo), points
the timeshift path at it, opens the channel's cache, then fills the tmpfs:
the cache must report a write error.  Once the filler is removed, the error
must clear within a minute and a half, and the cache must grow on disk
again.  The settings are put back and the tmpfs is unmounted.  It needs
--ssh, sudo without a password on the server, and no cache yet for the
channel, since a cache keeps the directory it was opened in.
"""
import time

from common import PASS, FAIL, ABSENT
import htsp as H

NUMBER, TITLE = 39, "a cache goes back to the disk once it has room again"
NEEDS_LOG = True
SID = 92
MNT = "/tmp/tvh-c39"
SETTINGS = ("path", "ram_only", "ram_size", "max_size", "unlimited_size", "record_cache")


def _wait(ctx, h, seconds, cond):
    """Pump the stream until cond(entry) holds; the entry, or None, and when."""
    t0 = time.time()
    while time.time() - t0 < seconds:
        ctx.pump(h, 3)
        e = ctx.cache_entry() or {}
        if cond(e):
            return e, time.time() - t0
    return None, time.time() - t0


def run(ctx):
    if not (ctx.ssh_target and ctx.log_path):
        return ABSENT, "needs --ssh and --log to mount a small filesystem on the server"
    if "entries" not in ctx.jload("/status/caches"):
        return ABSENT, "this build has no api/status/caches"
    busy = ctx.server_in_use()
    if busy:
        return ABSENT, "%s; this check changes the timeshift path" % busy
    ctx.drop_warm()
    if ctx.cache_entry():
        return (ABSENT, "%s has a cache already, and a cache keeps the directory it was "
                        "opened in; run this check once it has gone" % ctx.channel_name)
    if ctx.log("sudo -n true && echo ok") != "ok":
        return ABSENT, "sudo without a password is not available on the server"
    avail = ctx.log("awk '/MemAvailable/ {print int($2 / 1024)}' /proc/meminfo")
    size = max(32, min(160, int(avail or 0) // 4))
    if ctx.log("sudo -n mkdir -p %s && sudo -n mount -t tmpfs -o size=%dm,mode=1777 "
               "tvh-c39 %s && echo ok" % (MNT, size, MNT)) != "ok":
        return ABSENT, "could not mount a tmpfs at %s" % MNT

    before = ctx.timeshift()
    h = None
    try:
        ctx.timeshift(path=MNT, record_cache=True, ram_only=False, ram_size=8,
                      unlimited_size=False, max_size=4096)
        h = ctx.connect()
        H._subscribe(h, SID, ctx.chan_id)
        e, _ = _wait(ctx, h, 60, lambda e: e.get("disk", 0) > 2e6)
        if e is None:
            return FAIL, "the cache wrote nothing to %s in 60 s" % MNT
        if "write_error" not in e:
            return ABSENT, "this build does not report a cache's write errors"

        ctx.log("dd if=/dev/zero of=%s/fill bs=1M 2>/dev/null; sync; true" % MNT)
        e, t_err = _wait(ctx, h, 40, lambda e: e.get("write_error"))
        if e is None:
            return FAIL, "no write error with the %d MB tmpfs full" % size
        disk_full = e.get("disk", 0)

        ctx.log("rm -f %s/fill" % MNT)
        e, t_back = _wait(ctx, h, 90, lambda e: not e.get("write_error")
                          and e.get("disk", 0) > disk_full + 2e6)
        if e is None:
            e = ctx.cache_entry() or {}
            return (FAIL, "a write error %.0f s after the tmpfs filled, still %s 90 s "
                          "after it was freed (disk %.1f MB)"
                    % (t_err, "reported" if e.get("write_error") else "growing no more",
                       e.get("disk", 0) / 1e6))
        return (PASS, "a write error %.0f s after the %d MB tmpfs filled; writing again "
                      "%.0f s after it was freed, disk %.1f -> %.1f MB"
                % (t_err, size, t_back, disk_full / 1e6, e.get("disk", 0) / 1e6))
    finally:
        if h is not None:
            try:
                h.send(method="unsubscribe", subscriptionId=SID)
                ctx.pump(h, 2)
                h.s.close()
            except Exception:
                pass
        # the cache lets go of its files when the shared cache is turned off
        ctx.timeshift(record_cache=False)
        time.sleep(8)
        ctx.timeshift(**{k: before.get(k) for k in SETTINGS if k in before})
        ctx.log("rm -f %s/fill; sudo -n umount -l %s; sudo -n rmdir %s; true" % (MNT, MNT, MNT))
