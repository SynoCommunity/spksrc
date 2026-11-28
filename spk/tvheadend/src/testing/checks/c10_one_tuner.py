"""Two viewers, one tuner.

The promise of a per-channel cache: a second client watching the same channel
must not open a second input stream.  Counted through /api/status/inputs, which
lists what each adapter is actually pulling -- and filtered to this channel's
mux, since a server in use is tuned to other channels as well.
"""
from common import PASS, FAIL
import htsp as H

NUMBER, TITLE = 10, "two clients, one input stream"


def run(ctx):
    h, sid = ctx.warm()
    second = ctx.connect()
    H._subscribe(second, 62, ctx.chan_id)
    ctx.pump(second, 14)
    ctx.second, ctx.second_sid = second, 62
    subs = len(ctx.subscriptions(mine=True))
    streams = len(ctx.input_streams(mine=True))
    return (PASS if subs >= 2 and streams == 1 else FAIL,
            "%d subscriptions on this channel, %d input stream(s) for its mux"
            % (subs, streams))
