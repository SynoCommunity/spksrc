"""A radio service whose AAC comes from libfdk_aac.

Check 19 takes whatever radio service it is pointed at, and its AAC usually
comes from one encoder.  The cache calibrates a service with no video on its
audio frames -- a replayed frame must match one, and only one, of the frames
recently sent live -- so the encoder that made them is part of what is tested:
libfdk_aac does not frame or fill the way ffmpeg's native encoder does.  This
check makes its own: a temporary IPTV network whose one mux runs

    pipe://<ffmpeg> -re -f lavfi -i anoisesrc=color=pink:... \\
        -c:a libfdk_aac -b:a 96k -f mpegts pipe:1

maps it to a channel carrying the tags of --channel's (so that the same user
sees it), rewinds twice and comes back to live, then deletes the network and
the channel.  <ffmpeg> is $TVH_FFMPEG, by default the ffmpeg8
package's /usr/local/bin/ffmpeg8; it needs libfdk_aac, which --ssh lets the
check verify first.  With --log, a calibration warning in the server log
fails it even when the seeks were answered.

The same source through libfdk_aac on a pure tone (sine=frequency=440) gives
frames that repeat exactly every 75, which no frame-matching calibration can
tell apart: that is why the source here is noise.
"""
import json
import os
import time

from common import Ctx, ABSENT, PASS, FAIL

NUMBER, TITLE = 28, "a radio service encoded by libfdk_aac"

NAME = "tvh-check-28 libfdk"
SOURCE = "anoisesrc=color=pink:amplitude=0.2:sample_rate=48000"


def _wait(fn, seconds):
    end = time.time() + seconds
    while time.time() < end:
        v = fn()
        if v:
            return v
        time.sleep(2)
    return None


def run(ctx):
    ffmpeg = os.environ.get("TVH_FFMPEG", "/usr/local/bin/ffmpeg8")
    if ctx.ssh_target:
        enc = ctx.log("%s -hide_banner -encoders 2>/dev/null | grep -c libfdk_aac" % ffmpeg) \
            if ctx.log_path else ""
        if enc.strip() == "0":
            return ABSENT, "%s has no libfdk_aac encoder (set TVH_FFMPEG)" % ffmpeg
    url = ("pipe://%s -loglevel quiet -re -f lavfi -i %s "
           "-c:a libfdk_aac -b:a 96k -f mpegts pipe:1" % (ffmpeg, SOURCE))

    net = chan = None
    sub = None
    try:
        net = ctx.jload("/mpegts/network/create", {
            "class": "iptv_network",
            # max_timeout: a slow box takes longer than a few seconds to start
            # ffmpeg, and the first scan of the mux gives up on "no data"
            "conf": json.dumps({"networkname": NAME, "skipinitscan": True,
                                "max_streams": 2, "max_timeout": 60})}).get("uuid")
        if not net:
            return ABSENT, "could not create an IPTV network (admin rights?)"
        mux = ctx.jload("/mpegts/network/mux_create", {
            "uuid": net,
            "conf": json.dumps({"iptv_url": url, "iptv_muxname": NAME,
                                "iptv_sname": NAME, "enabled": 1})}).get("uuid")
        if not mux:
            return ABSENT, "could not create the IPTV mux"
        ctx.save(uuid=mux, scan_state=1)

        def service():
            for e in ctx.jload("/mpegts/service/grid?limit=1000").get("entries", []):
                if e.get("network_uuid") == net or e.get("network") == NAME:
                    return e.get("uuid")
            return None
        svc = _wait(service, 90)
        if not svc:
            return (ABSENT, "the mux gave no service: does %s run on the server, "
                    "with libfdk_aac?" % ffmpeg)
        # the tags of the --channel channel: access to channels is often
        # limited by tag, and this one has to be visible to the same user
        tags = ctx.entry(ctx.chan_uuid).get("tags") or [] if ctx.chan_uuid else []
        chan = ctx.jload("/channel/create", {
            "conf": json.dumps({"name": NAME, "services": [svc], "tags": tags,
                                "enabled": True})}).get("uuid")
        if not chan:
            return ABSENT, "could not create the channel"

        sub = Ctx(ctx.host, ctx.user, ctx.password, NAME, http=ctx.http,
                  htsp=ctx.htsp_port, ssh_target=ctx.ssh_target,
                  log_path=ctx.log_path)
        why = []
        if not _wait(lambda: _resolves(sub, why), 60):
            return FAIL, "the new channel never resolved: %s" % (why[-1] if why else "?")
        mark = sub.log_mark()
        h, sid = sub.warm(window=50, limit=150)
        # with timeshift off, skips still get an answer -- the time asked
        # for, echoed -- so a range on offer is what says it is on
        st = sub.pump(h, 8) or {}
        if not st.get("end"):
            return ABSENT, "no timeshift range offered: is timeshift enabled?"
        a = sub.position(sub.skip(h, sid, -30))
        b = sub.position(sub.skip(h, sid, -15)) if a is not None else None
        # past the live end: the server takes the client back to live
        live = sub.skip(h, sid, 3600) if b is not None else None
        warn = sub.log_since(mark, "unable to line the cache up", 2) if mark else ""
        if a is None or b is None:
            return FAIL, "answered SMT_SKIP_ERROR%s" % (" (" + warn.splitlines()[-1][-80:] + ")"
                                                       if warn else "")
        if warn:
            return FAIL, "seeks answered, but the log says: %s" % warn.splitlines()[-1][-90:]
        return (PASS if live is not None and not live.get("error") else FAIL,
                "rewound to %.1f s then %.1f s, %s" % (
                    a, b, "back to live" if live is not None and not live.get("error")
                    else "no way back to live"))
    finally:
        if sub is not None:
            sub.drop_warm()
        if chan:
            ctx.api("/idnode/delete", "uuid=" + chan)
        if net:
            ctx.api("/idnode/delete", "uuid=" + net)


def _resolves(sub, why):
    try:
        sub.resolve()
        return True
    except SystemExit as e:
        why.append(str(e)[:120])
        return False
