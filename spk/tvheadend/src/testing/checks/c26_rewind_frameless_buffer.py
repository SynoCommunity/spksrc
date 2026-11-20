"""Rewinding over a Classic buffer that holds no frame does not crash.

A skip looks for the indexed frame nearest the requested time.  When no
segment holds one, it falls back to the last segment it looked at -- whose
reference the step past it had already given up.  The reader then held a
segment nothing pinned, and at the end of that segment it released it once
more: `timeshift_file_put0()` asserts and the server aborts.

The code is master's, and master crashes on it too.  A buffer with no frame
follows a return to live while the buffer is full, which flushes every
segment: until the next I-frame reaches the new one, nothing in the buffer
holds a frame, and a rewind then takes the faulty fallback.  The budget
decides how often the buffer is full -- on master at each rotation once the
budget is spent, with the series also whenever the first write to a new
segment frees the old one whole.  This check produces it: Classic timeshift
(channel cache off) on a 1 MB budget, then for 150 s a rewind, a return to
live, and the next rewind a moment later, at delays short enough to land
before the next I-frame.  It passes if the server answered every skip and is
still up.  The settings are restored afterwards; if the server went down they are
restored when it comes back, by the runner.  It will not run while a
recording is in progress.
"""
from common import PASS, FAIL, ABSENT
import htsp as H
import time

NUMBER, TITLE = 26, "rewinding a buffer with no frame"
SID = 86


def run(ctx):
    busy = ctx.server_in_use()
    if busy:
        return (ABSENT, "%s; this check shrinks the "
                        "shared budget" % busy)
    ctx.drop_warm()
    before = ctx.timeshift()
    h = None
    skips = answered = 0
    died = None
    try:
        ctx.timeshift(record_cache=False, max_size=1)
        h = ctx.connect()
        H._subscribe(h, SID, ctx.chan_id)
        ctx.pump(h, 8)
        delays = (0.0, 0.02, 0.05, 0.1, 0.2, 0.35)
        end, i = time.time() + 150, 0
        while time.time() < end:
            try:
                skips += 1
                if ctx.skip(h, SID, seconds=-30) is not None:
                    answered += 1
                h.send(method="subscriptionLive", subscriptionId=SID)
                time.sleep(delays[i % len(delays)])
                i += 1
            except (OSError, EOFError) as e:
                died = "%s after %d skip(s)" % (type(e).__name__, skips)
                break
    finally:
        if h is not None:
            try:
                h.send(method="unsubscribe", subscriptionId=SID)
                ctx.pump(h, 2)
                h.s.close()
            except Exception:
                pass
        time.sleep(2)
        up = bool(ctx.jload("/serverinfo"))
        if up:
            ctx.timeshift(record_cache=before.get("record_cache"),
                          max_size=before.get("max_size"))

    if died or not up:
        crash = ctx.log("sudo -n grep -ahE 'CRASH: (Signal|timeshift)' /var/log/messages "
                        "2>/dev/null | tail -2") if ctx.ssh_target else ""
        return (FAIL, "server went down (%s)%s" % (died or "no answer to the API",
                                                   "; " + crash.replace("\n", " | ")[:160]
                                                   if crash else ""))
    return (PASS, "%d rewinds over a 1 MB budget, %d answered, server still up"
                  % (skips, answered))
