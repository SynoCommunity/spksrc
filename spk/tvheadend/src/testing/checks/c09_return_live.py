"""Coming back to live.

`subscriptionLive` returns the client to the present; the shift reported
afterwards must be about zero.  A client stuck a few seconds behind after
pressing Live would drift further with every pause.
"""
from common import PASS, FAIL

NUMBER, TITLE = 9, "return to live"


def run(ctx):
    h, sid = ctx.warm()
    h.send(method="subscriptionLive", subscriptionId=sid)
    st = ctx.pump(h, 8) or {}
    shift = st.get("shift", 0) / 1e6
    ctx.last_position = None
    return (PASS if abs(shift) < 6 else FAIL, "shift %.1f s" % shift)
