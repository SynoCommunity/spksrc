"""Rewinding into the part of a cache that is on disk.

A cache keeps its blocks in RAM while the RAM budget allows, and sends the rest
to disk; a client rewinding reads whichever its position falls in, the disk
part through a read that keeps its segment open meanwhile.

This check lowers the RAM budget to 8 MB for its run, so that from then on the
channel's new blocks go to disk, subscribes, waits for api/status/caches to
show a stretch on disk at least 10 s behind live and inside the client's seek
range, and rewinds into the middle of it: the client must land within 3 s of
that point and get packets again.  The budget is put back afterwards.  Under
"RAM only" nothing goes to disk, and the check reports absent.
"""
import time

from common import PASS, FAIL, ABSENT
import htsp as H

NUMBER, TITLE = 30, "rewind into the part of the cache on disk"

SID = 83
DISK = 3


def _disk_target(e, reach):
    """Seconds behind live of the middle of the newest stretch on disk that is
    at least 10 s back and no further back than `reach`, or None."""
    m = e.get("map") or []
    n, span = len(m), e.get("span", 0)
    if not n or span <= 0:
        return None
    width = (span + 1) / n
    best = None
    i = 0
    while i < n:
        j = i
        while j < n and m[j] == DISK:
            j += 1
        if j - i >= 3:
            mid = (i + j) / 2
            behind = span - mid * width
            if 10 <= behind <= reach:
                best = behind
        i = j + 1 if j == i else j
    return best


def _packets(h, seconds):
    end, n = time.time() + seconds, 0
    while time.time() < end:
        msg = h.recv(3)
        if msg and msg.get("method") == "muxpkt":
            n += 1
    return n


def run(ctx):
    if "entries" not in ctx.jload("/status/caches"):
        return ABSENT, "this build has no api/status/caches"
    busy = ctx.server_in_use()
    if busy:
        return (ABSENT, "%s; this check shrinks the "
                        "shared budget" % busy)
    before = ctx.timeshift()
    if before.get("ram_only"):
        return ABSENT, "\"RAM only\" is set: nothing goes to disk"
    h = None
    try:
        ctx.timeshift(ram_size=8)
        h = ctx.connect()
        H._subscribe(h, SID, ctx.chan_id)
        target = None
        st = {}
        end = time.time() + 150
        while time.time() < end and target is None:
            st = ctx.pump(h, 5) or {}
            reach = (st.get("end", 0) - st.get("start", 0)) / 1e6 - 5
            e = ctx.cache_entry()
            if e and reach > 10:
                target = _disk_target(e, reach)
        if target is None:
            return FAIL, "no stretch on disk 10 s back within the seek range after 150 s"

        st = ctx.pump(h, 2) or st
        expected = st.get("end", 0) / 1e6 - target
        landed = ctx.position(ctx.skip(h, SID, seconds=-target))
        if landed is None:
            return FAIL, "answered SMT_SKIP_ERROR rewinding %.0f s onto disk" % target
        got = _packets(h, 5)
        off = landed - expected
        ok = abs(off) <= 3 and got > 0
        return (PASS if ok else FAIL,
                "rewound %.0f s onto disk, landed %+.1f s from it, %d packets after"
                % (target, off, got))
    finally:
        if h is not None:
            try:
                h.send(method="unsubscribe", subscriptionId=SID)
                ctx.pump(h, 2)
                h.s.close()
            except Exception:
                pass
        ctx.timeshift(ram_size=before.get("ram_size"))
