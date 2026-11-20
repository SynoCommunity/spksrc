"""A recording that starts before Record was pressed.

The reason the cache exists.  A recording armed for a programme already under
way is fed the cache first and only then the live stream, so the file begins
where the cache reached rather than where the button was pressed.

Measured in the server log, which says how far back it went and how much it
replayed -- a file size would not distinguish a replay from ordinary live
recording without knowing the channel's bitrate.
"""
from common import PASS, FAIL, ABSENT
import time

NUMBER, TITLE = 15, "recording replays the cache"
NEEDS_LOG = True


def run(ctx):
    if not (ctx.ssh_target and ctx.log_path):
        return (ABSENT, "needs --ssh and --log to read the server log")
    h, sid = ctx.warm(95)
    mark = ctx.log_mark()
    now = int(ctx.now())
    u = ctx.create_entry(start=now + 10, stop=now + 220,
                         title={"eng": "replay check"}, __cache_full=1)
    ctx.pump(h, 45)
    said = ctx.log_since(mark, "replayed .* from the cache", 2)
    ctx.replay_entry = u
    return (PASS if said else FAIL,
            said.split("]")[-1].strip()[:64] if said else "the log shows no replay")
