"""Editing a retrospective recording while it replays.

A recording of a programme that has already finished is replayed out of the
cache, so its stop time is in the past from the moment it starts.  Anything
that asks the scheduler to look at the entry again -- an edit in the web
interface, an EPG update -- therefore reaches the wall-clock path, finds the
stop behind it, and can cut the replay short.

The replay of a whole programme takes seconds, so "was it still running
afterwards" proves nothing.  The check is differential instead: it records the
same finished event twice, once left alone and once edited the moment it
starts, and compares the two files.  They read the same stretch of cache, so
they should be the same size; a replay cut short by the edit is a fraction.

Three things must line up for it to run at all, and it says which is missing:

  * the entry must come from an EPG event -- the retrospective mode is armed
    only when one is attached, and only over HTSP: the HTTP API builds its own
    entry and drops the marker;
  * the event must have ended.  The EPG grid stops listing an event once it
    has, so name it with --event (note the id while it is still on);
  * the cache must cover the whole programme, or the gate refuses and records
    nothing -- deliberately, so that it cannot hand over live TV in place of
    history it does not have.  So someone must have been watching the channel
    since before the programme began.
"""
from common import PASS, FAIL, ABSENT
import time

NUMBER, TITLE = 21, "editing a running retrospective recording"


def _find(ctx, short_id):
    """The entry whose HTSP id this is: the first four bytes of its uuid."""
    for e in ctx.jload("/dvr/entry/grid?limit=100").get("entries", []):
        u = e.get("uuid") or ""
        try:
            if int.from_bytes(bytes.fromhex(u[:8]), "little") & 0x7FFFFFFF == short_id:
                return u
        except ValueError:
            pass
    return None


def _replay(ctx, h, event_id, seq, edit):
    """Arm the event, optionally edit it at once; return (size, status, note)."""
    h.send(method="addDvrEntry", eventId=event_id, seq=seq)
    reply = h.wait(None, timeout=25, seq=seq) or {}
    if not reply.get("success"):
        return None, None, "the server would not arm it: %r" % reply.get("error")
    u = None
    for _ in range(40):
        u = _find(ctx, reply.get("id"))
        if u:
            break
        time.sleep(0.25)
    if not u:
        return None, None, "the entry it created could not be found"

    note = ""
    if edit:
        ctx.save(uuid=u, comment="edited while replaying")
        note = ctx.entry(u).get("sched_status") or "?"

    end, st = time.time() + 240, {}
    while time.time() < end:
        st = ctx.entry(u)
        if st.get("sched_status") not in ("recording", "scheduled"):
            break
        time.sleep(3)
    size, status = st.get("filesize") or 0, st.get("status")
    ctx.drop_entry(u)
    return size, status, note


def run(ctx):
    event_id = getattr(ctx, "event_id", None)
    if not event_id:
        return (ABSENT, "name a finished event with --event; the EPG grid "
                        "stops listing one once it has ended")

    h, sid = ctx.warm()
    plain, status0, note0 = _replay(ctx, h, int(event_id), 88, edit=False)
    if plain is None:
        return (ABSENT, note0)
    if not plain:
        return (ABSENT, "the replay recorded nothing (%s): the cache does not "
                        "hold the whole programme" % status0)

    time.sleep(5)
    edited, status1, at_edit = _replay(ctx, h, int(event_id), 89, edit=True)
    if edited is None:
        return (ABSENT, at_edit)

    whole = edited >= 0.95 * plain
    detail = ("%d bytes left alone, %d edited at once (entry was %r just after "
              "the edit; ended %s)" % (plain, edited, at_edit, status1))
    if whole and at_edit != "recording":
        return (ABSENT, "the replay had finished before the edit landed; " + detail)
    return (PASS if whole else FAIL, detail)
