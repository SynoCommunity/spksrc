"""A recording interrupted by a transport error.

A lost signal must not end a recording: the thread waits and picks the stream
back up when it returns.  Plain master behaves that way, and the series under
test did not -- a cache-owned recording ended on the first error, bytes frozen
and never resumed.

The service is disabled for twenty seconds to produce a real interruption,
then re-enabled.  The file size before, during and after tells the story --
but `filesize` is the size of the entry's last file only, and a recording
that resumes does so in a new file, on master as with the series.  So the
proof that it resumed is that it is still recording and that its current
file still grows between two readings ten seconds apart, not a comparison
of the new file with the old one.
"""
from common import PASS, FAIL, ABSENT
import time

NUMBER, TITLE = 16, "recording survives a transport error"


def run(ctx):
    other = ctx.others_watching(ctx.channel_name)
    if other:
        return (ABSENT, "someone else is watching the channel (%s); this check "
                        "turns its service off for a while" % other)
    u = getattr(ctx, "replay_entry", None)
    if not u:
        now = int(ctx.now())
        u = ctx.create_entry(start=now + 10, stop=now + 240,
                             title={"eng": "interruption check"}, __cache_full=1)
        ctx.replay_entry = u
        time.sleep(40)
    before = ctx.entry(u).get("filesize", 0)

    ctx.save(uuid=ctx.service, enabled=False)
    time.sleep(22)
    during = ctx.entry(u)
    ctx.save(uuid=ctx.service, enabled=True)
    time.sleep(45)
    after = ctx.entry(u)
    time.sleep(10)
    later = ctx.entry(u)
    ctx.during_status = during

    alive = later.get("sched_status") == "recording"
    grew = (later.get("filesize") or 0) > (after.get("filesize") or 0)
    return (PASS if (alive and grew) else FAIL,
            "%s bytes, held at %s, resumed to %s then %s"
            % (before, during.get("filesize"), after.get("filesize"), later.get("filesize")))
