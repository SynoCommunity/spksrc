# tvheadend timeshift checks

End-to-end checks for tvheadend's timeshift, written while reviewing the shared
per-channel cache of [tvheadend#2249][pr]. They drive a real server over HTSP
and the HTTP API and report what it does, so a change can be compared against
the build before it.

[pr]: https://github.com/tvheadend/tvheadend/pull/2249

```
tvh-runtests.py --host nas --user someone --password secret --channel "BBC One"
tvh-runtests.py --list              what each check establishes
tvh-runtests.py --describe 18       the long explanation for one
tvh-runtests.py 15 21-23            only those
tvh-runtests.py 21 --event 1345055  check 21 needs a finished EPG event (see --describe 21)
tvh-runtests.py --help              everything above, with the options
```

Every option has an environment variable (`TVH_HOST`, `TVH_USER`, `TVH_PASS`,
`TVH_CHANNEL`, `TVH_HTTP`, `TVH_HTSP`, `TVH_SSH`, `TVH_LOG`, `TVH_AXIS`), so a
run can be repeated from a shell profile or a CI job without a long command.

## Examples

### Getting started

Run every check, the runner choosing the channels:

```
./tvh-runtests.py --host nas --user someone --password secret
```

It watches a few channels for six seconds each and sorts them by what the
checks need: fast ones (1 MB/s and more, high definition), slow ones (under
0.6 MB/s, standard definition) and radio, leaving out those that gave errors
or no data, those someone else is watching and those with a recording due
within two hours.  Channels whose name says radio, audio or FM are tried
first, the API not telling which services are radio.  Each check says which
kind it wants -- `NEEDS` in its file, a fast channel when it says nothing --
and gets it; a check comparing two gets a second.  The choice is kept in
`~/.tvh-tests/HOST.json` (`--state` to put it elsewhere) and reused, so that
the next runs use the same channels; each run first checks those still give
data, and chooses again when one does not.  `--rediscover` chooses again
anyway.  It does not choose while someone else is using the server, unless
`--ignore-viewers` says so, and lets go of the caches its probes opened.

Or run every check on one channel. Pick a channel that is on the air all the
time; the checks tune it, and several record from it for a minute or two:

```
./tvh-runtests.py --host nas --user someone --password secret --channel "BBC One"
```

`--channel` and `--second-channel`, when given, are used instead of the state.

Keep the connection in the environment, and the commands get short:

```
export TVH_HOST=nas TVH_USER=someone TVH_PASS=secret TVH_CHANNEL="BBC One"
./tvh-runtests.py
```

Read what a check does before running it:

```
./tvh-runtests.py --list          one line each
./tvh-runtests.py --describe 13   what check 13 establishes, and why
```

Run a few only: the timeshift basics that plain master passes too, or one
check again after a change:

```
./tvh-runtests.py 1-9
./tvh-runtests.py 16 17
```

Let the checks read the server log as well. The ssh login must work without a
password prompt (a key); on a SynoCommunity package the log is under the
package's `var/`:

```
./tvh-runtests.py --ssh someone@nas --log /var/packages/tvheadend/var/tvheadend.log
```

### Going further

**Comparing two builds.** The report is made to be compared. Run it once on
each build with a label, and after installing a build wait for the server's
start-up work (EPG grabbing, scans) to finish -- about five minutes on a NAS:

```
./tvh-runtests.py --label before > before.log
# install the other build, wait about five minutes
./tvh-runtests.py --label after > after.log
verdicts() { sed -n '/^RESULTS/,$p' "$1" | awk '{for (i = 2; i <= NF; i++) if ($i ~ /^(pass|fail|absent)$/) { print $1, $i; break }}'; }
diff <(verdicts before.log) <(verdicts after.log)
```

What is left is the checks whose verdict changed, for instance `< 26 fail` and
`> 26 pass`; their figures are in each log. The figures move from one run to
the next even when nothing changed -- checks 1 to 9 by tenths of a second --
so compare them side by side rather than with `diff`; see *Reading the
numbers* below for what a larger move means.

**A channel with no video, for check 19.** Point `--channel` at a radio
service if the lineup has one. Otherwise generate one: an IPTV network with a
mux whose URL runs ffmpeg. It needs an ffmpeg with `lavfi`; on Synology that is
the SynoCommunity ffmpeg package, not DSM's own `/usr/bin/ffmpeg`:

```
pipe:///usr/local/bin/ffmpeg8 -loglevel quiet -re -f lavfi -i sine=frequency=440:sample_rate=48000 -c:a aac -b:a 96k -f mpegts pipe:1
```

Map the service it finds to a channel, give that channel a tag the test user's
access entry allows, and run the checks that make sense without video:

```
./tvh-runtests.py 1-9 19 --channel "audio test"
```

**Check 28, AAC from libfdk_aac.** It needs no prepared channel: it creates a
temporary IPTV network whose mux runs `$TVH_FFMPEG` (by default
`/usr/local/bin/ffmpeg8`) to encode pink noise with `libfdk_aac`, maps it to a
channel carrying the tags of `--channel`, rewinds it twice, and deletes the
network and the channel again. With `--ssh` and `--log` it also checks that the
encoder exists, and fails on a calibration warning in the log:

```
./tvh-runtests.py 28 --channel "audio test" --ssh admin@nas --log /var/packages/tvheadend/var/tvheadend.log
```

**Check 21, a programme that has ended.** It records a finished programme out
of the cache, so the cache must hold the programme whole, and the event id
must be noted while the programme is on: the EPG grid stops listing an event
once it has ended. Before the programme starts, schedule a *Timeshift cache
only* entry on it, or keep a client on the channel; while it airs, note its id
(the programme on now comes first):

```
curl -s --digest -u someone:secret "http://nas:9981/api/epg/events/grid?limit=3&sort=start&channel=BBC%20One" \
  | python3 -c 'import json,sys; [print(e["eventId"], e["title"]) for e in json.load(sys.stdin)["entries"]]'
```

Once it has ended, and while the cache still covers it:

```
./tvh-runtests.py 21 --event 1345055
```

**On a server the household is using.** Checks 18, 25, 26, 30 to 34 and 39
change server-wide timeshift settings for a few minutes: 18 and 31 turn on
*RAM only*, 32 sets the RAM budget to nothing and a small size budget, 25 and
26 shrink the shared size budget to 1 MB, 30 the RAM budget to 8 MB, 39 points the timeshift path at a small tmpfs, so the other channels' caches -- a recording's included -- stop growing
meanwhile. They refuse to run while a recording is in progress or someone
else is watching, and say so as `absent` -- `--ignore-viewers` lets them run
past someone watching, who may then see the budgets shrink, never past a
recording; 16 and 23, which turn the channel's
service off for a while, refuse while someone else watches that channel. Check 26 aborts a build without its fix -- that is its point -- so on
such a build run it last, or alone, and start the server again afterwards (on
Synology DSM does not: `sudo synopkg start tvheadend`):

```
./tvh-runtests.py 1-25
./tvh-runtests.py 26
```

**In a script.** The exit status is 1 when any check fails and 0 otherwise;
`absent` is neither:

```
./tvh-runtests.py 1-12 > timeshift.log || echo "timeshift regressed, see timeshift.log"
```

**Adding a check.** Drop a file in `checks/` named after its number, say
`checks/c27_rewind_30.py`: the runner picks up every `c*.py` there, in order,
and `--list` and `--describe 27` show it at once. A minimal one:

```python
"""Rewinding thirty seconds lands thirty seconds back.

The docstring is what --describe prints: say what the check establishes and
what used to go wrong.
"""
from common import PASS, FAIL

NUMBER, TITLE = 27, "rewind 30 s"


def run(ctx):
    h, sid = ctx.warm()               # a subscription that has been running a while
    pos = ctx.position(ctx.skip(h, sid, seconds=-30))
    if pos is None:
        return (FAIL, "the server refused the rewind")
    return (PASS, "landed at %.1f s" % pos)
```

## What is here

| file | |
|---|---|
| `tvh-runtests.py` | finds the checks, runs the ones asked for, prints the report |
| `common.py` | the context a check is handed: HTTP, HTSP, the server log, a warm subscription |
| `htsp.py` | a small HTSP client: hello, digest authentication, subscribe, skip, live |
| `channels.py` | chooses the channels to run on, and keeps the choice in a state file |
| `sharing.py` | what checks 31 and 32 share: two caches on one budget |
| `checks/cNN_*.py` | one check each, saying what it establishes and why |

A check is a module with `NUMBER`, `TITLE`, a docstring explaining what it is
for, and `run(ctx)` returning a verdict and a sentence; `NEEDS` says which
kinds of channel it wants -- `("hd",)` when it says nothing, `("hd", "sd")`
for a fast one and a slow one, `("radio",)`.  Adding one is adding a file;
nothing else has to change.

## Verdicts

- **pass** / **fail** — the check ran, and the server did or did not behave.
- **absent** — this build does not offer the feature, or the setup cannot
  produce the situation. Reported apart from a failure: it is what lets one run
  cover a build with the cache series and one without, and it says which
  precondition was missing rather than leaving a bare failure.

## Reading the numbers

Checks 1 to 9 are timeshift basics that plain master passes too. They are the
control group: when one of them fails, suspect the harness or an unrelated
regression before suspecting the feature under test. In a three-way comparison
they land within tenths of a second of each other, which is what makes the
differences below them worth reading.

Checks 10 to 13 are the shared cache. The one that separates it from ordinary
timeshift is 11: a client watching for fourteen seconds asks to go back a
minute. With a buffer of its own it lands a second in; with a cache belonging
to the channel it reaches material captured before it arrived.

Checks 14 to 17 are recordings, and 16 and 17 read together: a recording
interrupted by a transport error either resumes (`recordingError`) or ends
(`completedError`).

Checks 18 to 26 cover the paths that rounds of review fixes opened, and each
says in its own file what used to go wrong there.

Check 27 is for the web interface's cache status page: it holds the
page to what an HTSP client is really offered, and is absent on a build
without it. Check 29 holds the same page to who is in a cache: a paused
viewer, named with its client, and a recording that started on time, with the
span of its programme and the bytes it is made of. Check 30 rewinds into the
part of a cache that has gone to disk.

**Checks 31 and 32, two caches sharing a budget.** 31 under *RAM only*, 32
with no RAM, on disk. They need a second channel and a server with no cache
yet, as the settings apply to the caches opened after them: run them first,
on a server just started or once the keepalives have expired, each on its
own run so that the first one's caches do not linger into the second:

```
./tvh-runtests.py 31 --channel "BBC One" --second-channel "BBC Two"
./tvh-runtests.py 32 --channel "BBC One" --second-channel "BBC Two"
```

The second channel's cache fills the budget alone and is left to the
keepalive with nobody watching; the channel's own must then reach most of
its share, half the budget, and get it gradually, as it fills it. A cache
keeps the mode it was opened in, so the two caches 31 leaves stay *RAM
only* for as long as the keepalive holds them: start the server again
before other checks on those channels.

**Check 33, changing the settings live.** With a viewer on the channel, it
goes through RAM then disk, *RAM only*, no RAM, and RAM then disk again, and
holds the cache status to each; then it lets the viewer go and turns the
shared cache off, which must let go of the keepalive and of the cache. It
puts every setting back.

**Check 34, RAM in front of the disk.** With RAM and a disk, a cache writes
everything to disk and keeps its newest part in RAM as well: the check holds
the cache status to that, and rewinds a few seconds into the RAM part.

**Check 35, playing backwards.** It plays a few seconds backwards and seeks
meanwhile; on the audio-only channel too, where any packet is a point to go
back to:

```
./tvh-runtests.py 1-9 19 35 --channel "audio test"
```

**Check 36, seeking after pausing.** It does what a viewer does before
moving to the end of the seek bar, Kodi's right arrow held to the end: a
rewind and back to live, a recording of the channel starting, two pauses,
then an absolute seek just short of live, followed by the 4x Kodi sends,
which must be answered -- before, the client froze on its last picture --
one 30 s back, which must land where it asked, and one past the end, which
must be answered too. It creates a recording for the while and removes it,
and, when nobody else uses the server, lowers the RAM budget so that the
seek goes from the disk part of the cache into the RAM part; the setting is
put back.

**Check 37, the same after a long session.** Check 36 at the scale the
freeze was seen at: half an hour on the channel before the recording starts,
ten minutes of recording, a four-minute pause. It takes some 45 minutes and
runs only when asked for:

```
./tvh-runtests.py 37 --channel "ICI Radio-Canada"
```

**Check 38, RAM shared between a fast cache and a slow one.** With RAM and a
disk, the caches share the RAM their newest copies take.  A high-definition
cache reserves a copy ten times as often as a standard-definition one, so the
room given back to the slow cache must stay for it rather than go back to
the fast one.  The faster channel fills 64 MB of RAM, then a viewer joins the
slower one and pauses; within four minutes the slow cache must hold in RAM
most of what it has written, up to an even split, and the fast one no more
than the rest -- the share is max-min fair.  The two channels must differ in
bitrate threefold:

```
./tvh-runtests.py 38 --channel "ICI Radio-Canada" --second-channel "Me TV"
```

**Check 39, back to the disk once it has room again.** A cache whose write
fails -- the volume full -- keeps new data off the disk, in RAM while it has
room, and tries the disk again every 30 s.  The check mounts a small tmpfs
on the server over ssh (sudo without a password), points the timeshift path
at it, opens the channel's cache and fills the tmpfs: the cache must report
a write error, and once the filler is removed, clear it within a minute and
a half and grow on disk again.  It wants no cache yet for the channel, since a
cache keeps the directory it was opened in, and puts the path back:

```
./tvh-runtests.py 39 --channel "ICI Radio-Canada"
```

**Check 40, a slow channel's RAM share holds its data.** The RAM budget
charges what malloc() takes, and a cache's 256 KiB blocks are sealed when
full or a second old, so a standard-definition channel's are two thirds
full.  A sealed block's allocation is brought down to its data; with a
viewer on a slow channel for a minute, the cache's RAM data must be at least
nine tenths of what that RAM is charged.  It changes no setting:

```
./tvh-runtests.py 40 --channel "Me TV"
```

**Check 41, the caches' RAM goes back to the system.** Brought down to
what they hold, the blocks end up of every size; kept in the heap, the
tails they give back would be holes that fragment it.  Their data lives in
pages of its own instead.  With 64 MB of RAM, a fast channel's cache and a
slow one's fill it for a minute and close: of the resident memory the
process gained, three quarters must be gone ten seconds later.  It reads
the process's memory over ssh and turns the shared cache off and on:

```
./tvh-runtests.py 41 --channel "Télé-Québec" --second-channel "Me TV"
```

Check 25 also pauses its client for 20 s once the Classic buffer has
recovered: with nothing to free, the writer retries once a second, and must
not leave an empty file behind each time.  It counts the files under the
timeshift path over ssh, and skips that part when the path is the default.

## What a run changes

The checks create DVR entries, briefly disable a service to interrupt a
recording, lower the RAM and size budgets, and (check 28) add an IPTV network
and a channel of their own. Each undoes what it changed before it
returns, including when it fails, and the report says what was restored. The
user needs streaming, DVR and admin rights. The runner also takes a copy of the
timeshift settings before the first check and writes it back at the end.

Two checks read `tvheadend.log` over ssh and report `absent` without `--ssh`
and `--log`.
