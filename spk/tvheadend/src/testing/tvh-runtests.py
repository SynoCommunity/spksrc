#!/usr/bin/env python3
"""Run the tvheadend timeshift checks against a live server.

Each check lives in its own file under checks/, says what it establishes, and
is run on its own or with the others.  They drive a real server over HTSP and
the HTTP API: nothing is simulated, and every figure printed is a measurement.

Connection
----------
Give it on the command line, or in the environment:

    tvh-runtests.py --host nas --user someone --password secret --channel "BBC One"
    TVH_HOST=nas TVH_USER=someone TVH_PASS=secret TVH_CHANNEL="BBC One" tvh-runtests.py

    --http PORT     HTTP port, default 9981          (TVH_HTTP)
    --htsp PORT     HTSP port, default 9982          (TVH_HTSP)
    --ssh TARGET    host the server log can be read from, e.g. user@nas (TVH_SSH)
    --log PATH      path to tvheadend.log there      (TVH_LOG)
    --label TEXT    what to call this run in the report (TVH_AXIS)
    --event ID      a finished EPG event still held in the cache, for check 21
                    (TVH_EVENT); note its id while the programme is still on
    --second-channel NAME
                    another channel, for the checks that compare two (TVH_CHANNEL2)
    --state PATH    where the channels chosen are kept, default
                    ~/.tvh-tests/HOST.json (TVH_STATE)
    --rediscover    choose the channels again rather than reuse the state's
    --ignore-viewers
                    run the checks that change server-wide settings even while
                    someone else is watching (TVH_IGNORE_VIEWERS); their
                    picture may suffer meanwhile.  A recording in progress
                    still makes them stand aside

Two checks read the server log and report ABSENT without --ssh and --log.

Channels
--------
With no --channel, the runner chooses: it watches a few channels for some
seconds each and sorts them into high definition, standard definition and
radio, leaving out those that gave errors or no data, those someone else is
watching and those with a recording due.  Each check says which kind it
wants, and gets it.  The choice is kept in the state file and reused, so
that runs compare; a channel there that no longer gives data is replaced.
--channel and --second-channel, when given, are used instead.

Choosing checks
---------------
    tvh-runtests.py                 every check but 37 (45 minutes; name it)
    tvh-runtests.py 15 21-23        only those
    tvh-runtests.py --list          what each one establishes
    tvh-runtests.py --describe 18   the long explanation for one

The user needs streaming, DVR and admin rights: the checks create DVR entries
and briefly disable a service to interrupt a recording.  Each undoes what it
changed, and says so.

Verdicts
--------
    pass / fail   the check ran and the server did, or did not, behave
    absent        this build does not offer the feature, which is not a failure
                  -- it is what lets the same run cover a build with the cache
                  series and one without
"""
import argparse
import json
import importlib.util
import os
import sys
import time
import traceback

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from common import Ctx, PASS, FAIL, ABSENT                  # noqa: E402
import channels                                              # noqa: E402


def load_checks():
    """Every checks/cNN_*.py, in order."""
    out = []
    d = os.path.join(HERE, "checks")
    for name in sorted(os.listdir(d)):
        if not name.startswith("c") or not name.endswith(".py"):
            continue
        spec = importlib.util.spec_from_file_location(name[:-3], os.path.join(d, name))
        mod = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)
        if hasattr(mod, "NUMBER") and hasattr(mod, "run"):
            out.append(mod)
    return sorted(out, key=lambda m: m.NUMBER)


def parse_wanted(tokens):
    want = set()
    for t in tokens:
        for part in t.replace(",", " ").split():
            if "-" in part:
                a, b = part.split("-", 1)
                want.update(range(int(a), int(b) + 1))
            elif part.isdigit():
                want.add(int(part))
    return want


def main():
    p = argparse.ArgumentParser(
        prog="tvh-runtests.py", add_help=False,
        description="Run the tvheadend timeshift checks against a live server.")
    p.add_argument("checks", nargs="*", help="numbers or ranges, e.g. 15 21-23")
    p.add_argument("-h", "--help", action="store_true")
    p.add_argument("--list", action="store_true")
    p.add_argument("--describe", type=int, metavar="N")
    p.add_argument("--host", default=os.environ.get("TVH_HOST"))
    p.add_argument("--user", default=os.environ.get("TVH_USER"))
    p.add_argument("--password", default=os.environ.get("TVH_PASS"))
    p.add_argument("--channel", default=os.environ.get("TVH_CHANNEL"))
    p.add_argument("--http", default=os.environ.get("TVH_HTTP", "9981"))
    p.add_argument("--htsp", default=os.environ.get("TVH_HTSP", "9982"))
    p.add_argument("--ssh", default=os.environ.get("TVH_SSH", ""))
    p.add_argument("--log", default=os.environ.get("TVH_LOG", ""))
    p.add_argument("--label", default=os.environ.get("TVH_AXIS", ""))
    p.add_argument("--event", default=os.environ.get("TVH_EVENT", ""))
    p.add_argument("--second-channel", default=os.environ.get("TVH_CHANNEL2", ""))
    p.add_argument("--ignore-viewers", action="store_true",
                   default=bool(os.environ.get("TVH_IGNORE_VIEWERS")))
    p.add_argument("--state", default=os.environ.get("TVH_STATE", ""))
    p.add_argument("--rediscover", action="store_true")
    a = p.parse_args()

    if a.help:
        print(__doc__)
        return 0

    checks = load_checks()

    if a.list:
        for m in checks:
            print("%2d  %-44s %s" % (m.NUMBER, m.TITLE,
                                     "needs the server log" if getattr(m, "NEEDS_LOG", False) else ""))
        return 0

    if a.describe:
        for m in checks:
            if m.NUMBER == a.describe:
                print("%d  %s\n" % (m.NUMBER, m.TITLE))
                print((m.__doc__ or "").strip())
                return 0
        print("no check numbered %d" % a.describe)
        return 1

    for need, flag in (("host", "--host"), ("user", "--user"),
                       ("password", "--password")):
        if not getattr(a, need):
            print("missing %s (or TVH_%s); tvh-runtests.py --help"
                  % (flag, need.upper()[:4]), file=sys.stderr)
            return 2

    want = parse_wanted(a.checks)
    # with none named, all but those that only run when asked for (ON_REQUEST)
    todo = [m for m in checks
            if m.NUMBER in want or (not want and not getattr(m, "ON_REQUEST", False))]
    if not todo:
        print("no check matches %s; tvh-runtests.py --list" % " ".join(a.checks), file=sys.stderr)
        return 2

    server = Ctx(a.host, a.user, a.password, None,
                 http=a.http, htsp=a.htsp, ssh_target=a.ssh, log_path=a.log)
    server.ignore_viewers = a.ignore_viewers
    roles = {}
    if not a.channel:
        path = channels.state_path(a.host, a.state or None)
        print("channels: %s" % path, flush=True)
        roles = channels.ensure(server, path, a.rediscover,
                                log=lambda line: print(line, flush=True)).get("roles", {})
        if "hd" not in roles:
            print("no channel to run on was found; name one with --channel", file=sys.stderr)
            return 2
    contexts = {}

    def ctx_for(name):
        """One context per channel, kept across the checks that share it."""
        if name not in contexts:
            c = Ctx(a.host, a.user, a.password, name,
                    http=a.http, htsp=a.htsp, ssh_target=a.ssh, log_path=a.log).resolve()
            c.event_id = int(a.event) if str(a.event).isdigit() else None
            c.ignore_viewers = a.ignore_viewers
            contexts[name] = c
        return contexts[name]

    def setup(m):
        """The context a check runs in: the channels it wants."""
        need = getattr(m, "NEEDS", ("hd",))
        name = a.channel or roles.get(need[0]) or roles["hd"]
        c = ctx_for(name)
        second = a.second_channel or (roles.get(need[1]) if len(need) > 1 else None)
        c.second_channel = second or None
        return c

    ctx = setup(todo[0])
    label = a.label or "%s, %s" % (a.host, ("channel %s" % a.channel) if a.channel else
                                   ", ".join("%s %s" % (r, roles[r]) for r in channels.ROLES
                                             if r in roles))
    print("=" * 78)
    print("tvheadend timeshift checks -", label)
    cfg = ctx.timeshift()
    print("  shared cache: %s   keepalive: %s   seek before tune-in: %s"
          % (cfg.get("record_cache", "absent"), cfg.get("cache_keepalive", "absent"),
             cfg.get("cache_seek_tunein", "absent")))
    print("=" * 78, flush=True)

    # Checks change settings and put them back, but a server killed mid-check
    # or a build that drops settings it does not know would leave them changed:
    # take a copy now and write it back whatever happens.
    snapshot = {k: v for k, v in ctx.timeshift().items() if v is not None}

    results = []
    try:
        _run(todo, setup, results)
    finally:
        for c in contexts.values():
            c.drop_warm()
        ctx.api("/timeshift/config/save", "node=" + json.dumps(snapshot))

    print()
    print("=" * 78)
    print("RESULTS -", label)
    for n, t, v, d in results:
        print("  %2d %-44s %-7s %s" % (n, t, v, d))
    print("  pass=%d  fail=%d  absent=%d"
          % (sum(1 for r in results if r[2] == PASS),
             sum(1 for r in results if r[2] == FAIL),
             sum(1 for r in results if r[2] == ABSENT)))
    return 1 if any(r[2] == FAIL for r in results) else 0


def _run(todo, setup, results):
    for m in todo:
        started = time.time()
        try:
            verdict, detail = m.run(setup(m))
        except Exception:
            verdict, detail = FAIL, "the check itself failed: " + \
                traceback.format_exc(limit=1).strip().split("\n")[-1]
        results.append((m.NUMBER, m.TITLE, verdict, detail))
        print("  [%-6s] %2d %-42s %s  (%.0fs)"
              % (verdict, m.NUMBER, m.TITLE, detail, time.time() - started), flush=True)


if __name__ == "__main__":
    sys.exit(main())
