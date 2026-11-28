"""A service carrying no video.

The cache lines a replayed frame up with the same frame sent live by
fingerprinting video, and a seek lands on a video keyframe.  A radio service
has neither, so without a path of its own it never calibrates: pause answers
speed 100 and every seek answers SMT_SKIP_ERROR.

Point --channel at a radio service and run checks 1 to 9 against it: they
exercise exactly what breaks.  A television service whose video component is
switched off in the web interface does just as well.  One can also be made
from nothing, if the server has a full ffmpeg:

    IPTV mux URL:  pipe:///usr/local/bin/ffmpeg -loglevel quiet -re \\
                   -f lavfi -i sine=frequency=440:sample_rate=48000 \\
                   -c:a aac -f mpegts pipe:1

giving a channel with one audio stream and nothing else.
"""
from common import ABSENT, PASS, FAIL

NUMBER, TITLE = 19, "a service with no video"
NEEDS = ("radio",)


def run(ctx):
    # This is about a service with no video, so say which it is rather than
    # pretend to have tested one.  The stream list is the authority: a service
    # grid row only names the service, not what it carries.
    h, sid = ctx.warm()
    start = ctx.start_message or {}
    streams = start.get("streams") or []
    if isinstance(streams, dict):
        streams = list(streams.values())
    video = [s for s in streams
             if isinstance(s, dict) and
             any(k in str(s.get("type", "")).upper()
                 for k in ("H264", "HEVC", "MPEG2VIDEO", "VP8", "VP9", "AV1"))]
    if video:
        return (ABSENT,
                "%r carries video (%s); point --channel at a radio service"
                % (ctx.channel_name, video[0].get("type")))
    p = ctx.position(ctx.skip(h, sid, -30))
    return (PASS if p is not None else FAIL,
            "reached %.1f s with no video to anchor on" % p if p is not None
            else "answered SMT_SKIP_ERROR")
