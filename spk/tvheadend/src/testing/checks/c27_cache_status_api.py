"""The cache status page describes what a client is actually offered.

api/status/caches -- the web interface's view of the shared channel
caches -- reports each cache: its bytes by place, the time
it spans, where its viewers stand, and a map of that span.  For the channel a
client has been watching, the page must list a cache spanning at least the
seek range the client is offered over HTSP, with that client among its
viewers; its bytes by place must add up to its size; and the client's own row
in api/status/subscriptions must say it is a viewer of that very cache, close
to live.  A build without the page reports absent.
"""
from common import PASS, FAIL, ABSENT

NUMBER, TITLE = 27, "the cache status page matches the client"


def run(ctx):
    if "entries" not in ctx.jload("/status/caches"):
        return (ABSENT, "this build has no api/status/caches")
    h, sid = ctx.warm()
    st = ctx.pump(h, 4) or {}
    window = (st.get("end", 0) - st.get("start", 0)) / 1e6
    d = ctx.jload("/status/caches")
    e = ctx.cache_entry()
    if e is None:
        return (FAIL, "no cache listed for the channel's services (%d listed)"
                      % len(d.get("entries", [])))
    subs = [s for s in ctx.subscriptions(mine=True)
            if s.get("username") == ctx.user and s.get("cache_role")]
    me = next((s for s in subs if s.get("cache") == e.get("uuid")), None)

    problems = []
    if e.get("span", 0) < window - 5:
        problems.append("spans %d s for an offered %.0f s" % (e.get("span", 0), window))
    if not e.get("viewers"):
        problems.append("lists no viewer")
    # with "disk" all that is written, RAM copies included, the part on disk
    # alone is what adds up with the RAM and the staged bytes
    placed = e.get("ram", 0) + e.get("staging", 0) + e.get("disk_only", e.get("disk", 0))
    if placed != e.get("size"):
        problems.append("bytes by place add up to %d, size says %s" % (placed, e.get("size")))
    m = e.get("map") or []
    if len(m) != 120 or any(c not in (0, 1, 2, 3) for c in m) or not any(m):
        problems.append("map is not 120 slots of places (%d slots)" % len(m))
    if me is None:
        problems.append("the client's subscription names no cache role")
    elif me.get("cache_role") != "viewer" or me.get("cache_behind", 99) > 10:
        problems.append("the client's subscription is %r, %s s behind"
                        % (me.get("cache_role"), me.get("cache_behind")))
    if "budget" not in d:
        problems.append("no budget beside the entries")

    detail = ("span %d s for an offered %.0f s, %d viewer(s), %.1f MB (RAM %.1f, waiting %.1f, "
              "disk %.1f)" % (e.get("span", 0), window, len(e.get("viewers") or []),
                              e.get("size", 0) / 1e6, e.get("ram", 0) / 1e6,
                              e.get("staging", 0) / 1e6, e.get("disk", 0) / 1e6))
    if me is not None:
        detail += ", client a %s %s s behind" % (me.get("cache_role"), me.get("cache_behind"))
    return (FAIL, "; ".join(problems) + " -- " + detail) if problems else (PASS, detail)
