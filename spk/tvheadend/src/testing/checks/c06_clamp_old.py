"""Asking to go further back than anything held.

A client that asks for an hour when the cache holds a minute must be given the
oldest thing there is, not an error and not a position that does not exist.
Clamping at the bottom is what lets a client offer a scrub bar without first
asking how deep the buffer goes.
"""
from common import PASS, FAIL

NUMBER, TITLE = 6, "rewind past the oldest data clamps"


def run(ctx):
    h, sid = ctx.warm()
    p = ctx.position(ctx.skip(h, sid, -9999))
    ctx.last_position = p
    return (PASS if p is not None else FAIL,
            "clamped to %.1f s" % p if p is not None else "answered SMT_SKIP_ERROR")
