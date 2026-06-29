# imagecache: throttle & now-first ordering

EPG sources that carry programme artwork expose hundreds of `<icon>` URLs. Tvheadend's imagecache fetches them on a single thread with **no pacing**, so on a guide grab it issues ~500 back-to-back HTTPS requests and the provider rate-limits/blocks the NAS IP (download failures in the log).

> Serving the raw URL with imagecache disabled does **not** help: such providers also hotlink-protect by `Referer` — a browser `<img>` sends `Referer` and gets `403`, while KODI/curl with no `Referer` get `200`. So caching server-side is the right path; it just must not hammer the source.

These providers limit **images per IP per time window** (observed on tvtv.ca: ~50 per ~60 min). A failed request returns nothing and does **not** consume quota; the quota refills from the last **success**. So the sustainable rate is *"B images per T minutes"*, and the throttle's job is to learn `B` and `T` and then never exceed them.

## Changes

### Now-first ordering (always on)

The fetch queue is sorted by a per-image priority instead of FIFO; EPG passes the programme start time so the visible "now" guide gets its images before far-future days (channel/dvr/rating icons keep priority 0).

- New `imagecache_get_id_prio()`; `imagecache_get_id()` is a `prio=0` wrapper.
- A shared image URL keeps the soonest priority and is re-sorted if still queued.
- The thread always waits for the queue to be quiet (`IMAGECACHE_FETCH_SETTLE_MS`) before draining, so it drains a fully sorted queue rather than following a grab's (future-first) enqueue order.

### Download throttle — "Automatic download throttling" toggle (on by default)

Kept in small helpers (`imagecache_throttle_*`) out of the fetch loop.

- **Automatic — LEARN:** drain at full speed until blocked, then escalate a recovery pause up a ladder (5, 10, 15, 30, … min, kept strictly below the *Re-try period*) until a pause reliably refills the window — i.e. a window yields `>= IMAGECACHE_BATCH_MIN` images on `IMAGECACHE_LOCK_CONFIRM` tries **in a row**. Confirmation matters because one good window can be a fluke (the quota having refilled across earlier empty windows). That yields `B` (batch) and `T` (pause).
- **Automatic — OPERATE:** on lock it computes the sustainable pace `ms = T/B` and drives a **token bucket** — one token every `ms`, capacity `~B` (with margin). A full bucket after idle lets a small update burst at full speed; a large queue drains at the sustainable rate and stops getting blocked. It logs the learned budget and, when a whole queued batch fits the budget, `M images queued, within budget -- full speed`. A block while operating re-learns one rung slower (any operating block counts toward that, cleared by a clean burst).
- **Automatic — OPTIMIZE:** the learned `B per T` is a safe *lower* bound — the provider may sustain more if paced differently (the limit can be a mix of frequency and volume, not a flat count). After lock the throttle **binary-searches a faster pace**: it probes `ms/2` and, if that sustains `2×B` downloads **in a row** without a block, accepts it and probes faster; if a probe blocks first it takes one recovery pause and **bisects** between the fastest pace that failed and the slowest that held, converging on the fastest sustainable pace. Worst case it settles back on the learned `T/B`. The optimized pace is **persisted**, so a restart resumes there instead of re-probing. Each step logs (`probing N ms/image`, `N ms/image too fast`, `pace optimized -> N ms/image`).
- **Manual (toggle off):** two now-visible fields, *Minimum delay between downloads (ms)* and *Back-off pause on blocking (minutes)*, used verbatim (`0/0` = no throttling). In automatic mode those are read-only (`get_opts`) and mirror the learned pace and pause. Saving the Image Cache config now logs the effective throttle setting (`config saved -- throttle manual, N ms/image, M min pause`), so a manual rate change is visible in the log.

Only provider-block-like failures (`403`/`429`/`5xx`, timeout, dropped connection) count toward the back-off; a plain missing image (`404`/`410`) does **not**, so a few broken EPG URLs cannot trip a false block (`imagecache_image_fetch` now reports which it was).

The **on-demand web fetch path** (`imagecache_filename`) shares the same provider budget instead of bypassing it. It still fetches **immediately** — the active user viewing the guide must not wait — but it **debits one token** from the bucket, so the background pacer waits one extra interval to repay it and the combined thread + on-demand rate stays within the provider window (previously an active client browsing the guide could silently overrun the window and trip an hour-long recovery pause). While a back-off pause is active it skips the fetch and serves a `404` (the thread gets the image afterwards); and if an on-demand fetch *itself* trips a block, it arms the recovery pause, voids the now-moot catch-up debt, and re-queues the image for the thread to retry — further on-demand requests are served `404` until the window refills.

### Reset button & completion log

A **Reset auto-throttle** button on the Image Cache config toolbar (next to *Clean image cache* / *Re-fetch images*) drops the learned provider budget so the throttle re-learns from scratch: `imagecache_throttle_reset()` removes the persisted state and the fetch thread re-initialises (`api/imagecache/config/resetthrottle`, button in `webui/static/app/config.js`).

When the fetch queue drains after a pass (the initial fill, or an EPG update that pulled new images), the thread logs `fetch queue drained -- N image(s) fetched, M failed`, so the log shows when caching has caught up (100%).

### Fix a latent use-after-free in `imagecache_destroy()`

The fetch queue holds no reference, so destroying a still-queued image (`QUEUED` or pending `SAVE`) freed it and left a dangling `TAILQ` entry the fetch thread later dereferenced (`SIGABRT`). Unlink from the queue before `decref`. Latent in stock tvheadend (a clean/purge racing the fetch thread) but the back-off makes it reproducible: images sit `QUEUED` for the whole pause, so a clean during a pause almost always hits one.

Both metadata-save paths (the fetch thread and the on-demand fetch) release the lock to write the meta file; if a concurrent `destroy()` removes the image during that window they now drop the just-written meta file (re-checking `imagecache_by_id` after re-locking), so no orphan metadata survives without its data file.

---

Also aligns the existing *"Expire time"* label with the period settings (`(days)`).

---

## Validation — overnight run against a real provider (tvtv.ca)

### Auto-throttle full lifecycle

The throttle escalates pauses, **confirms** each candidate pause actually refills
the window, then **locks** onto the smallest pause that works — so it converges on
a sustainable rate instead of spiralling into ever-longer waits.

    21:04:36 [ INFO] auto-throttle: learning provider budget (pacing 250 ms/image until blocked)
    21:04:37 [ WARN] auto-throttle: provider blocking -> pausing 5 min
    21:09:37 [ WARN] auto-throttle: provider blocking -> pausing 10 min
    21:19:39 [ WARN] auto-throttle: provider blocking -> pausing 15 min
    21:35:02 [ INFO] auto-throttle: pausing 15 min works (~50 images), confirming
    21:50:03 [ WARN] auto-throttle: provider blocking -> pausing 30 min
    22:20:03 [ WARN] auto-throttle: provider blocking -> pausing 60 min
    23:20:27 [ INFO] auto-throttle: pausing 60 min works (~51 images), confirming
    00:20:49 [ INFO] auto-throttle: locked -- budget ~51 images / 60 min -> pacing 70588 ms/image, burst 38

| Phase | Log marker | What it proves |
|-------|-----------|----------------|
| Learn | `learning provider budget` | Probes at full speed until the first block |
| Escalate | `provider blocking -> pausing N min` | Walks the pause ladder (5→10→15→30→60) |
| Confirm | `pausing N min works (~B images), confirming` | A candidate pause is validated over consecutive windows, not trusted on a single fluke |
| Lock | `locked -- budget ~B images / T min -> pacing ms/image, burst N` | Settles on `ms = T/B` and stops escalating |

### Steady state after lock — token bucket in action

From the lock (00:20) to the end of the log (06:18): **203 images downloaded,
zero further escalation** — the lock holds. Each hourly refill releases a burst of
~38 images, then the remainder trickles out at the locked ~70 s/image rate. Sample
from the 04:02 refill (38 back-to-back, then the bucket is empty and the 39th waits
~70 s):

    04:02:03.392 imagecache: downloaded .../p350092_b_v9_ab.jpg
    04:02:03.817 imagecache: downloaded .../p13791449_st_h10_aa.jpg
    04:02:04.054 imagecache: downloaded .../p958387_b_v9_ab.jpg
    ... (38 images in ~17 s, draining the burst bucket) ...
    04:02:20.333 imagecache: downloaded .../p16271918_e_v10_aa.jpg
    04:02:20.799 imagecache: downloaded .../p15861423_e_v9_aa.jpg
    04:03:13.925 imagecache: downloaded .../p17474501_e_v13_aa.jpg   <- +53 s: bucket empty, back to locked pace

### Without the throttle — what users hit today

Stock imagecache has no pacing and no back-off: a guide grab fires requests
back-to-back, the provider blocks the NAS IP, and every following download just
fails. The only log line is "failed to download" -- nothing slows down or
recovers, so the failures continue until the grab ends and are retried (and fail
again) on the next pass.

    22:03:50 [ WARN] imagecache: failed to download .../p27127445_b_h8_aa.jpg
    22:03:50 [ WARN] imagecache: failed to download .../p220310_b_v9_ad.jpg
    22:03:51 [ WARN] imagecache: failed to download .../p18169151_e_v9_aa.jpg
    ... (continues back-to-back, no pacing, no back-off) ...

### On-demand requests are gracefully skipped while paused

While a back-off pause is active, the synchronous web-fetch path does not hammer
the blocking provider: it skips the fetch and serves a `404` placeholder; the
image is fetched by the thread once the pause clears.

    20:09:47 [DEBUG] imagecache: on-demand fetch skipped, backed off: .../p27322987_b_h2_ah.jpg
    20:09:47 [ERROR] http: 192.168.80.88: GET /imagecache/4501 -- 404
    20:09:48 [DEBUG] imagecache: on-demand fetch skipped, backed off: .../p55088_v_h2_ac.jpg
    20:09:48 [ERROR] http: 192.168.80.88: GET /imagecache/9668 -- 404
