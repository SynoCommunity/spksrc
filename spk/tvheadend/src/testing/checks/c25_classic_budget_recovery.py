"""Classic timeshift on a full size budget: it recovers, and closes once.

The channel cache and the Classic rolling buffer draw on one size budget.  When
a Classic write cannot get its share and nothing can be freed -- the only file
is the one being written -- the write fails, the segment is given up and
`ts->full` is set.  Two things then matter:

  * buffering must come back: that latch used to be cleared only by a client
    jumping back to live from a time-shifted position, so a viewer who stays
    live lost the buffer for the rest of the subscription;
  * the abandoned segment must be closed once: retrying rotates away from it,
    and closing it a second time writes an EOF marker to a closed descriptor,
    which the log reports as "unable to write timeshift EOF marker";
  * a paused client holds the oldest file, so nothing can be freed: the
    writer retries once a second, and must not leave an empty file behind
    each time.

The check shrinks the budget to 1 MB, well below one minute of stream, and turns the channel
cache off, so the client gets Classic timeshift on disk segments (on a RAM
segment a second close is silent).  It watches `full` go up and come back down
over a minute, reads the log for the second close, then pauses the client for
20 s and counts the files of the fullest Classic buffer under the timeshift
path (over ssh, with sudo; skipped when the path is the default one).  The settings are restored
afterwards.  It will not run while a recording is in progress,
since a tiny budget would starve every cache on the server meanwhile.
"""
from common import PASS, FAIL, ABSENT
import htsp as H
import time

NUMBER, TITLE = 25, "Classic timeshift recovers from a full budget"
NEEDS_LOG = True


def run(ctx):
    if not (ctx.ssh_target and ctx.log_path):
        return (ABSENT, "needs --ssh and --log to read the server log")
    busy = ctx.server_in_use()
    if busy:
        return (ABSENT, "%s; this check shrinks the "
                        "shared budget" % busy)
    ctx.drop_warm()
    before = ctx.timeshift()
    h = None
    try:
        ctx.timeshift(record_cache=False, ram_size=0, max_size=1)
        mark = ctx.log_mark()
        h = ctx.connect()
        H._subscribe(h, 85, ctx.chan_id)
        fulls, end = [], time.time() + 60
        while time.time() < end:
            m = h.recv(3)
            if m and m.get("method") == "timeshiftStatus":
                fulls.append(1 if m.get("full") else 0)
        files = None
        root = (before.get("path") or "").rstrip("/")
        if root:
            h.send(method="subscriptionSpeed", subscriptionId=85, speed=0)
            ctx.pump(h, 20)
            # each Classic buffer has a directory of its own: the most files
            # in one, so that another client's buffer does not count
            out = ctx.log("sudo -n sh -c 'for d in %s/buffer/*/; do ls \"$d\" | grep -c ^tvh-; "
                          "done' 2>/dev/null | sort -n | tail -1" % root)
            files = int(out) if out.isdigit() else None
            h.send(method="subscriptionSpeed", subscriptionId=85, speed=100)
        try:
            h.send(method="unsubscribe", subscriptionId=85)
            ctx.pump(h, 3)
            h.s.close()
        except Exception:
            pass
        h = None
        time.sleep(3)
        second_close = ctx.log_since(mark, "unable to write timeshift EOF marker", 20)
        closes = len([l for l in second_close.splitlines() if l.strip()])
    finally:
        if h is not None:
            try:
                h.send(method="unsubscribe", subscriptionId=85)
                h.s.close()
            except Exception:
                pass
        ctx.timeshift(record_cache=before.get("record_cache"),
                      ram_size=before.get("ram_size"),
                      max_size=before.get("max_size"))

    if 1 not in fulls:
        return (ABSENT, "the budget never filled in 60 s; the channel's bitrate "
                        "is too low even for a 1 MB budget")
    first = fulls.index(1)
    recovered = 0 in fulls[first:]
    stops = sum(1 for a, b in zip(fulls, fulls[1:]) if a == 0 and b == 1)
    detail = ("buffer stopped %d time(s), %s; %d second close(s) in the log"
              % (stops, "resumed each time" if recovered else "never resumed", closes))
    if files is not None:
        detail += "; %d Classic file(s) after 20 s paused" % files
    ok = recovered and closes == 0 and (files is None or files <= 3)
    return (PASS if ok else FAIL, detail)
