"""Choosing the channels the checks run on, and remembering them.

With no --channel, the runner picks channels itself: it watches a few for
some seconds each -- what they carry, how fast, and whether the server saw
errors on them -- and sorts them into high definition, standard definition
and radio.  A check says which kind it wants (NEEDS in its file).  The
choice is kept in a state file per server, so that the next runs use the
same channels and find the server in the same state; it is made again with
--rediscover, or when a channel kept there no longer gives data.

Fast means at least 1 MB/s, slow under 0.6 MB/s.  A channel someone else
is watching, or one with a recording due within two
hours, is not probed.  Probing opens a cache per channel, so the caches are
let go afterwards -- the shared cache turned off and on -- as the checks
that measure budgets want a server with none.
"""
import json
import os
import re
import time

import htsp as H

ROLES = ("hd", "hd2", "sd", "radio")
KINDS = {"hd": "hd", "hd2": "hd", "sd": "sd", "radio": "radio"}
PROBE_SECONDS = 6
CHECK_SECONDS = 3
MAX_PROBES = 16
SID = 99
VIDEO = ("H264", "HEVC", "MPEG2VIDEO", "MPEG4VIDEO", "VP8", "VP9", "AV1", "THEORA")


def state_path(host, path=None):
    return path or os.path.join(os.path.expanduser("~"), ".tvh-tests", "%s.json" % host)


def load(path):
    try:
        with open(path) as f:
            return json.load(f)
    except (OSError, ValueError):
        return None


def save(path, state):
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    tmp = path + ".tmp"
    with open(tmp, "w") as f:
        json.dump(state, f, indent=1, sort_keys=True)
    os.replace(tmp, path)


def _errors(ctx, name):
    """The server's error count on our probing subscription to `name`."""
    for s in ctx.subscriptions():
        if s.get("channel") == name and s.get("username") == ctx.user:
            return int(s.get("errors") or 0)
    return 0


def probe(ctx, name, chan_id, seconds=PROBE_SECONDS):
    """Watch a channel for a few seconds: what it carries, its rate, errors."""
    info = {"at": int(time.time())}
    h = ctx.connect()
    try:
        start = H._subscribe(h, SID, chan_id)
        if not start or start.get("error"):
            info["error"] = (start or {}).get("error") or "no start"
            return info
        streams = start.get("streams") or []
        video = [s for s in streams if any(k in str(s.get("type", "")).upper() for k in VIDEO)]
        info["video"] = video[0].get("type") if video else None
        info["height"] = max([int(s.get("height") or 0) for s in video] or [0])
        info["audio"] = len([s for s in streams if s not in video
                             and "SUBTITLE" not in str(s.get("type", "")).upper()
                             and "TELETEXT" not in str(s.get("type", "")).upper()])
        got, t0 = 0, time.time()
        while time.time() - t0 < seconds:
            m = h.recv(2)
            if m and m.get("method") == "muxpkt" and m.get("subscriptionId") == SID:
                got += len(m.get("payload") or b"")
        info["rate"] = int(got / seconds)
        info["errors"] = _errors(ctx, name)
    finally:
        try:
            h.send(method="unsubscribe", subscriptionId=SID)
            time.sleep(1)
            h.s.close()
        except Exception:
            pass
    return info


HD_RATE, SD_RATE = 1.0e6, 0.6e6       # bytes/s


def kind(info):
    """hd, sd, radio, or None for a channel not worth testing on.  The
    checks care about the rate rather than the picture: a fast channel
    fills the budgets, a slow one shows what a cache of little data does.
    A 720p subchannel at 0.3 MB/s is a slow one; one in between is left
    out, as neither."""
    if not info or info.get("error") or not info.get("rate") or info.get("errors"):
        return None
    if not info.get("video"):
        return "radio" if info.get("audio") else None
    if info["rate"] >= HD_RATE:
        return "hd"
    return "sd" if info["rate"] < SD_RATE else None


def _due(ctx, hours=2):
    """Channels with a recording due within `hours`."""
    soon = time.time() + hours * 3600
    out = set()
    for e in ctx.jload("/dvr/entry/grid_upcoming?limit=500").get("entries", []):
        if e.get("enabled", True) and (e.get("start_real") or e.get("start") or 0) < soon:
            out.add(e.get("channelname"))
    return out


def _assign(probed):
    """The roles, from the channels probed: the cleanest of each kind first,
    and among high-definition ones the fastest, among standard-definition
    ones the slowest -- what the checks comparing them want."""
    by = {"hd": [], "sd": [], "radio": []}
    for name, info in probed.items():
        k = kind(info)
        if k:
            by[k].append((name, info))
    by["hd"].sort(key=lambda x: (x[1].get("errors", 0), -x[1].get("rate", 0)))
    by["sd"].sort(key=lambda x: (x[1].get("errors", 0), x[1].get("rate", 0)))
    by["radio"].sort(key=lambda x: (x[1].get("errors", 0), x[0]))
    roles = {}
    if by["hd"]:
        roles["hd"] = by["hd"][0][0]
    if len(by["hd"]) > 1:
        roles["hd2"] = by["hd"][1][0]
    if by["sd"]:
        roles["sd"] = by["sd"][0][0]
    if by["radio"]:
        roles["radio"] = by["radio"][0][0]
    return roles


def _filled(roles):
    return all(r in roles for r in ("hd", "hd2", "sd"))


def discover(ctx, chans, log=print):
    """Probe channels until the roles are filled; the new state."""
    if ctx.server_in_use():
        raise SystemExit("not choosing channels while the server is in use (%s); "
                         "name them with --channel" % ctx.server_in_use())
    numbers = {e.get("name"): e.get("number") or 0
               for e in ctx.jload("/channel/grid?limit=1000").get("entries", [])
               if e.get("enabled")}
    due = _due(ctx)
    # the API does not say which services are radio: the names that suggest
    # it are probed first, then the others by number
    def hinted(n):
        return re.search(r"radio|audio|\bfm\b", n, re.I) is not None

    def number(n):
        v = str(numbers[n])
        return float(v) if v.replace(".", "", 1).isdigit() else 1e9
    order = sorted((n for n in numbers if n in chans.values()),
                   key=lambda n: (not hinted(n), number(n), n))
    ids = {v: k for k, v in chans.items()}
    probed = {}
    for name in order:
        roles = _assign(probed)
        if len(probed) >= MAX_PROBES or (_filled(roles) and ("radio" in roles or not hinted(name))):
            break
        if name in due or ctx.others_watching(name):
            continue
        info = probe(ctx, name, ids[name])
        probed[name] = info
        log("  probed %-24s %s" % (name, describe(info)))
    _let_go(ctx)
    return {"host": ctx.host, "at": int(time.time()), "probed": probed, "roles": _assign(probed)}


def _let_go(ctx):
    """Close the caches the probes opened -- unless someone else is on the
    server: turning the shared cache off would empty theirs too, and the
    probes' caches go of themselves once kept long enough."""
    if ctx.others_watching():
        return
    conf = ctx.timeshift()
    if conf.get("record_cache"):
        ctx.timeshift(record_cache=False)
        time.sleep(8)
        ctx.timeshift(record_cache=True)
        time.sleep(3)


def describe(info):
    if not info:
        return "-"
    if info.get("error"):
        return "no stream (%s)" % info["error"]
    return "%s %sp, %.2f MB/s, %d error(s) -> %s" % (
        info.get("video") or "audio", info.get("height") or "?", info.get("rate", 0) / 1e6,
        info.get("errors", 0), kind(info) or "left out")


def ensure(ctx, path, rediscover=False, log=print):
    """The roles to run with: the state file's when its channels still give
    data, else chosen anew (and saved)."""
    chans = _channel_ids(ctx)
    state = None if rediscover else load(path)
    if state and state.get("roles"):
        bad = []
        for role, name in state["roles"].items():
            if name not in chans.values():
                bad.append(name)
                continue
            if ctx.others_watching(name):
                continue                     # in use: kept, not probed now
            info = probe(ctx, name, {v: k for k, v in chans.items()}[name], CHECK_SECONDS)
            if kind(info) != KINDS[role]:
                bad.append(name)
                log("  %s (%s) no longer fits: %s" % (name, role, describe(info)))
        if not bad:
            _let_go(ctx)
            return state
        log("  choosing channels again")
    state = discover(ctx, chans, log)
    save(path, state)
    return state


def _channel_ids(ctx):
    h = H.Htsp(ctx.host, ctx.htsp_port)
    h.login(ctx.user, ctx.password)
    try:
        return H._channels(h)
    finally:
        try:
            h.s.close()
        except Exception:
            pass
