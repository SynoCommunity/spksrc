"""A cache warmup must not keep an autorec rule from recording.

Before an autorec rule schedules a programme it looks for an entry already on
that broadcast, and gives up if it finds one: the programme is taken care of.
A "Timeshift cache only" entry fills the cache without writing a file, so it
takes care of nothing a recording rule wants -- yet it matched like any
recording, and the rule recorded nothing.  Keeping completed warmups around,
which stops a cache-only rule spawning the same warmup twice, made this more
likely, not less.  The rule's recording then met the warmup a second time:
creating an entry deletes it as a duplicate of any entry on the same channel,
configuration, owner and start time -- the warmup included.

The check needs a programme that airs once on the channel and has not started:
it schedules a warmup on it, then an autorec rule for the same title with an
ordinary configuration, and looks for the recording that rule should create.
When there is none, it runs the rule again without the warmup: only if the
rule records then is the warmup to blame.  Everything it made is deleted
before it returns.
"""
from common import PASS, FAIL, ABSENT
import json
import re
import time

NUMBER, TITLE = 24, "a warmup does not block an autorec recording"


def _unique_upcoming(ctx):
    now = ctx.now()
    ev = ctx.jload("/epg/events/grid?limit=1000&channel=" + str(ctx.chan_uuid)) \
            .get("entries", [])
    count = {}
    for e in ev:
        count[e.get("title")] = count.get(e.get("title"), 0) + 1
    later = [e for e in ev
             if count.get(e.get("title")) == 1 and e.get("title")
             and e.get("start", 0) - now > 30 * 60]
    return min(later, key=lambda e: e.get("start", 0)) if later else None


def _rule(ctx, ev):
    conf = {"enabled": True, "title": "^%s$" % re.escape(ev.get("title")),
            "channel": ctx.chan_uuid, "config_name": ctx.dvr_config,
            "maxsched": 1, "comment": "tvh-runtests check 24"}
    return ctx.jload("/dvr/autorec/create", "conf=" + json.dumps(conf)).get("uuid")


def _recordings(ctx, rule):
    """Entries the rule spawned that will write a file."""
    time.sleep(8)
    spawned = [e for e in ctx.jload("/dvr/entry/grid?limit=500").get("entries", [])
               if e.get("autorec") == rule]
    return [e for e in spawned if not ctx.entry(e.get("uuid")).get("cache_only")]


def _drop_rule(ctx, rule):
    if not rule:
        return
    for e in ctx.jload("/dvr/entry/grid?limit=500").get("entries", []):
        if e.get("autorec") == rule:
            ctx.api("/idnode/delete", "uuid=" + e.get("uuid"))
    ctx.api("/idnode/delete", "uuid=" + rule)
    time.sleep(2)


def run(ctx):
    props = {p.get("id") for p in
             (ctx.jload("/idnode/class?name=dvrentry") or {}).get("props", [])}
    if "cache_only" not in props:
        return (ABSENT, "this build has no cache_only property")
    ev = _unique_upcoming(ctx)
    if ev is None:
        return (ABSENT, "no programme airing once, at least half an hour away")

    warm = rule = None
    try:
        warm = ctx.create_entry(broadcast=ev.get("eventId"), cache_only=True,
                                start=ev.get("start"), stop=ev.get("stop"),
                                title={"eng": ev.get("title")})
        linked = ctx.entry(warm).get("broadcast")
        if not warm or not linked:
            return (ABSENT, "the warmup could not be tied to the broadcast")
        rule = _rule(ctx, ev)
        if not rule:
            return (ABSENT, "the autorec rule could not be created")
        beside = len(_recordings(ctx, rule))
        if beside:
            return (PASS, "%r: the rule scheduled %d recording(s) beside the warmup"
                          % (ev.get("title"), beside))

        # nothing: is it the warmup, or would the rule not record this anyway?
        _drop_rule(ctx, rule)
        ctx.api("/idnode/delete", "uuid=" + warm)
        warm = None
        time.sleep(2)
        rule = _rule(ctx, ev)
        alone = len(_recordings(ctx, rule)) if rule else 0
        if not alone:
            return (ABSENT, "%r: the rule schedules nothing even without a warmup"
                            % ev.get("title"))
        return (FAIL, "%r: the rule scheduled 0 recordings beside the warmup, "
                      "%d without it" % (ev.get("title"), alone))
    finally:
        _drop_rule(ctx, rule)
        if warm:
            ctx.api("/idnode/delete", "uuid=" + warm)
