"""The keepalive and a stream map that changes.

When a service's stream map changes, the subscribers are sent a stop carrying
SM_CODE_SOURCE_RECONFIGURED -- the service itself keeps running.  A keepalive
that treats every stop as the end queues itself for removal, the now-empty
service is stopped, and the cache it was holding is disconnected well before
the configured number of minutes is up.

Disabling and re-enabling the service produces that reconfiguration.  The
keepalive must still be there afterwards.
"""
from common import PASS, FAIL, ABSENT
import htsp as H
import time

NUMBER, TITLE = 23, "keepalive survives a reconfiguration"


def run(ctx):
    other = ctx.others_watching(ctx.channel_name)
    if other:
        return (ABSENT, "someone else is watching the channel (%s); this check "
                        "turns its service off for a while" % other)
    ctx.drop_warm()
    h = ctx.connect()
    H._subscribe(h, 84, ctx.chan_id)
    ctx.pump(h, 70)
    try:
        h.send(method="unsubscribe", subscriptionId=84)
        ctx.pump(h, 3)
        h.s.close()
    except Exception:
        pass
    time.sleep(10)

    before = [e for e in ctx.subscriptions() if "keepalive" in (e.get("title") or "")]
    if not before:
        return (ABSENT, "no keepalive to begin with")

    ctx.save(uuid=ctx.service, enabled=False)
    time.sleep(3)
    ctx.save(uuid=ctx.service, enabled=True)
    time.sleep(12)
    after = [e for e in ctx.subscriptions() if "keepalive" in (e.get("title") or "")]
    return (PASS if after else FAIL,
            "one before the reconfiguration, %d after" % len(after))
