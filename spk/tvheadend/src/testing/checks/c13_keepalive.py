"""The cache outliving its last viewer.

Everybody stops watching.  Without the series the service stops and its history
is gone; with it, a keepalive subscription holds the channel for the configured
number of minutes, so the next viewer -- or a recording started from the guide
-- still finds the programme that was on.

The check leaves, waits, looks for the keepalive, then connects afresh and asks
to go back further than the new client has been there.
"""
from common import PASS, FAIL
import htsp as H
import time

NUMBER, TITLE = 13, "cache outlives its last viewer"


def run(ctx):
    second = getattr(ctx, "second", None)
    if second is not None:
        try:
            second.send(method="unsubscribe", subscriptionId=ctx.second_sid)
            ctx.pump(second, 3)
            second.s.close()
        except Exception:
            pass
        ctx.second = None
    ctx.drop_warm()
    time.sleep(10)

    alive = [e for e in ctx.subscriptions() if "keepalive" in (e.get("title") or "")]
    if not alive:
        return (FAIL, "no keepalive subscription took over")

    fresh = ctx.connect()
    H._subscribe(fresh, 64, ctx.chan_id)
    ctx.pump(fresh, 12)
    p = ctx.position(ctx.skip(fresh, 64, -60))
    try:
        fresh.send(method="unsubscribe", subscriptionId=64)
        ctx.pump(fresh, 3)
        fresh.s.close()
    except Exception:
        pass
    return (PASS if p is not None else FAIL,
            "kept by %r; a new client reached %s"
            % (alive[0].get("title"),
               "%.1f s" % p if p is not None else "nothing"))
