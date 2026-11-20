"""Seeking to the very bottom of the advertised range.

With "Cache seek before tune-in" off, the range offered to a client starts at
its own zero, and asking to go there is an ordinary seek.  It is easy to get
wrong: if the pending position doubles as the flag that says a seek is
pending, then asking for zero looks exactly like asking for nothing, and the
client is left where it was with no reply it can act on.
"""
from common import PASS, FAIL
import htsp as H

NUMBER, TITLE = 20, "seek to the advertised lower bound"


def run(ctx):
    before = ctx.timeshift()
    try:
        ctx.timeshift(cache_seek_tunein=False)
        h = ctx.connect()
        H._subscribe(h, 82, ctx.chan_id)
        st = ctx.pump(h, 60) or {}
        low = st.get("start", 0)
        p = ctx.position(ctx.skip(h, 82, absolute=low))
        try:
            h.send(method="unsubscribe", subscriptionId=82)
            h.s.close()
        except Exception:
            pass
        return (PASS if p is not None else FAIL,
                "bound %.1f s, landed at %s"
                % (low / 1e6, "%.1f s" % p if p is not None else "SMT_SKIP_ERROR"))
    finally:
        ctx.timeshift(cache_seek_tunein=before.get("cache_seek_tunein"))
