"""How far back the server says a client may go.

A client learns its seek range from `timeshiftStatus`, which carries `start`
and `end`.  With the shared cache that range is what the channel's cache holds,
not what this client has buffered for itself -- which is the whole point of the
series under test.  Plain timeshift passes this too, so it is a control: a
failure here means the harness or the server, not the feature.
"""
from common import PASS, FAIL

NUMBER, TITLE = 1, "seek range offered to the client"


def run(ctx):
    h, sid = ctx.warm()
    st = ctx.pump(h, 4) or {}
    span = (st.get("end", 0) - st.get("start", 0)) / 1e6
    return (PASS if span > 30 else FAIL,
            "start %.0fs, end %.0fs, so %.0fs available"
            % (st.get("start", 0) / 1e6, st.get("end", 0) / 1e6, span))
