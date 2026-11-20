"""A DVR entry that fills the cache without recording anything.

"Timeshift cache only" schedules the channel to be tuned so its cache covers a
programme, without writing a file: you decide later whether to keep it.  The
entry must survive its own run -- it is the record of what was asked for, and
destroying it when the warmup ends makes a scheduled job vanish from the log
the moment it finishes.

The check schedules one for a minute and a half, watches it run, and looks for
it afterwards.
"""
from common import PASS, FAIL, ABSENT
import time

NUMBER, TITLE = 14, "DVR warmup entry survives its run"


def run(ctx):
    props = {p.get("id") for p in
             (ctx.jload("/idnode/class?name=dvrentry") or {}).get("props", [])}
    if "cache_only" not in props:
        return (ABSENT, "this build has no cache_only property")

    now = int(ctx.now())
    u = ctx.create_entry(start=now + 12, stop=now + 85,
                         title={"eng": "cache warmup check"}, cache_only=True)
    if not u:
        return (ABSENT, "the entry could not be created")
    deadline = time.time() + 100
    while time.time() < deadline:
        time.sleep(5)
    st = ctx.entry(u)
    survived = bool(st)
    if survived:
        ctx.api("/idnode/delete", "uuid=" + u)
    return (PASS if survived else FAIL,
            "finished as %r" % st.get("status") if survived else "the entry was destroyed")
