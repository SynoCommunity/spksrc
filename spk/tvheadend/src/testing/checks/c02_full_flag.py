"""The `full` flag a client is told about.

`timeshiftStatus` reports whether the buffer has stopped accepting data.  It
must be a plain 0 or 1: a client shows a different control when the buffer is
full, and a value from uninitialised memory would make that flicker.
"""
from common import PASS, FAIL

NUMBER, TITLE = 2, "the full flag is sane"


def run(ctx):
    h, sid = ctx.warm()
    st = ctx.pump(h, 4) or {}
    v = st.get("full")
    return (PASS if v in (0, 1, False, True) else FAIL, "full=%r" % (v,))
