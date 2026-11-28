"""Seeking after pausing, up to just short of live, after a long session.

Check 36 at the scale it was seen at: a channel watched for half an hour
before a recording of it starts, the recording running ten minutes while
the viewer watches on, then a pause of four minutes -- the viewer a few
minutes behind, which on an HD channel is where the cache's RAM part ends
and its disk part begins -- and the move to the end of the seek bar.  The
same seeks are made and held to the same answers; see check 36.  The RAM
budget is left as it is.

It takes some 45 minutes, and is only run when asked for.
"""
import importlib.util
import os

NUMBER, TITLE = 37, "seeking after pausing, after a long session"
ON_REQUEST = True     # some 45 minutes: not part of a run that names no check


def _c36():
    """Check 36's module, loaded as the runner loads checks: by its path."""
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        "c36_seek_after_pause.py")
    spec = importlib.util.spec_from_file_location("c36_seek_after_pause", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def run(ctx):
    # the RAM budget as it is: on an HD channel a few minutes of it, so the
    # viewer ends up where the RAM part of the cache begins
    return _c36().sequence(ctx, live_for=1800, recording_for=600, pause_for=240,
                           lower_ram=False)
