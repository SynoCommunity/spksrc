"""What the recording was called while the signal was gone.

The companion to the previous check, and the one that reads at a glance.  A
recording that merely lost its stream reports `recordingError` and is still
going; one that gave up reports `completedError`.  The difference is the whole
of the regression this series had against plain master.
"""
from common import PASS, FAIL, ABSENT

NUMBER, TITLE = 17, "status seen during the interruption"


def run(ctx):
    during = getattr(ctx, "during_status", None)
    if during is None and ctx.others_watching(ctx.channel_name):
        return (ABSENT, "check 16 left the channel alone: someone else is watching it")
    if during is None:
        return (FAIL, "run check 16 first; it produces the interruption")
    status = during.get("status")
    sched = during.get("sched_status")
    ended = sched == "completedError"
    u = getattr(ctx, "replay_entry", None)
    if u:
        ctx.drop_entry(u)
        ctx.replay_entry = None
    return (FAIL if ended else PASS, "%s / %s" % (status, sched))
