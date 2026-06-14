# imagecache: ship the EPG-vs-imagecache audit tool

Adds a small stdlib-only Python 3 tool, `lib/py/tvh/tv_imagecache_audit.py`, and installs it to `${bindir}` alongside the existing tvh python helpers (`tv_meta_*.py`). It cross-checks what the imagecache actually downloaded against the rolling EPG, bucketed by airing day, so the imagecache throttle / now-first ordering can be validated against the expected result.

## What it does

Each EPG grid event carries `image="imagecache/<id>"`; on disk `data/<id>` present means downloaded, `meta/<id>` is the JSON record. The tool joins the two and reports, per airing day: distinct images referenced, cached, still-to-download, and errors. It de-duplicates across days (a poster reused on many days is one fetch, not N) and shows a NOW-FIRST check (cached% among each day's first-seen images) to confirm soon-airing images are fetched first.

Views: default per-day table + breakdown; `--coverage` (one column per day, cached%); `--basic` (in-cache vs to-download); `--by-channel`; `--csv` (trend logging); plus `--day N`, `--details`, `--missing-only`, `--errors`, `--debug`.

## Path auto-detection (no arguments needed)

All derived from tvheadend itself, in order: the running tvheadend process command line (`/proc/<pid>/cmdline`: `-c`/`--config`, `-l`/`--logfile`, `--http_port`); the config dir tvheadend logs at startup (`Using configuration from '...'`); tvheadend's built-in default config dirs (`/var/lib/tvheadend`, `/etc/tvheadend`, `~/.hts/tvheadend`); and the current directory (offline analysis of copied files). The EPG comes from the live HTTP API when reachable, otherwise a saved `epg.json`. Any path can be overridden with `--imagecache`/`--log`/`--epg`/`--api`.

## configure / install

`configure` now propagates `--localstatedir` into `.config.mk` (previously accepted but dropped), and a standalone help page `docs/markdown/tv_imagecache_audit.md` is added (picked up by the docs wildcard); `support/posix.mk` substitutes it into the installed script (`@TVHEADEND_LOCALSTATEDIR@`) as a fallback config-dir default, so the tool also resolves the cache location when tvheadend is not running on installs whose data dir is none of the built-in defaults.
