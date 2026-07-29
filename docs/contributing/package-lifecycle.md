---
title: Package Lifecycle Policy
description: How SynoCommunity decides which packages stay active, which are disabled, and which are retired and archived
---

# Package Lifecycle Policy

When a package should no longer be offered for new installations, it follows **one of two distinct tracks**. The difference is whether the source is *kept dormant* in the repository or *removed* from it.

!!! note
    This is a living policy. Borderline cases are decided by the maintainers on the package's pull request or issue.

## The two tracks at a glance

| | **Disabled** (`BROKEN` / `DISABLED`) | **Retired** (archived) |
|---|---|---|
| Git repository | source **kept** (dormant) | source **removed** |
| Built / published | no | no |
| On the [package site](https://synocommunity.com/packages) | no longer offered | shown as **archived** |
| Basis for the decision | no longer supported **upstream**, but plausibly revivable | **too old and obviously obsolete** |
| Reversible? | yes — remove the `BROKEN` / `DISABLED` file | only by re-introducing the package |

In both cases, **existing installations keep working** — they simply receive no further updates.

## Active packages

A package stays active as long as it broadly satisfies all of the following:

- **It builds and runs** for at least one supported architecture/toolchain and starts on a current DSM release.
- **Its upstream is alive** and still supports an installation method compatible with how SynoCommunity ships it.
- **Its runtime is current** — it does not depend on a removed toolchain or an end-of-life runtime (e.g. Python 2, or an EOL Python 3.x).
- **It is the preferred version** — not superseded by a newer package.
- **It has a path to maintenance** — issues can realistically be fixed (an active maintainer, or a community-fixable build).

## Track 1 — Disabled (`BROKEN` / `DISABLED`, kept in git)

For packages that **upstream no longer supports** (or whose upstream dropped the installation method SynoCommunity relies on), but that are recent or relevant enough to keep **dormant and revivable**.

Typical reasons:

- **Upstream end-of-life**, or upstream removes the install method — e.g. `homeassistant` (the upstream "Core" / venv install was deprecated).
- **Superseded** by a newer package still in active use — e.g. `ffmpeg5` / `ffmpeg6` → `ffmpeg7`.
- **Depends on an EOL runtime** that may still return in another form — e.g. `python313`.

The source is **kept in the tree** so the work is preserved and the package can be brought back. It is not built and not published.

### How to disable

Create a marker file in the package folder — either `spk/<package>/BROKEN` or `spk/<package>/DISABLED`; both are accepted and have the same effect. Use `DISABLED` when the package is intentionally turned off (e.g. no release planned) and `BROKEN` when it is actually failing — pick whichever reads best. Give it a short, dated reason and a reference where applicable:

```text
Package no-longer maintained - superseded by ffmpeg7
```

```text
2025-12-01 (@maintainer) upstream deprecated the Core install method,
ref: https://www.home-assistant.io/blog/2025/05/22/deprecating-core-...
```

The build framework skips any package that has a `BROKEN` or `DISABLED` file, and CI stops publishing it.

### Reactivating

Removing the `BROKEN` / `DISABLED` file re-enables the package. This is appropriate when the blocking cause is resolved (upstream resumes support, a compatible runtime returns, the build is fixed) **and** a maintainer commits to keeping it working. A reactivation is validated by a normal build (locally or in CI) before merging.

## Track 2 — Retired (removed from git, archived online)

For packages that are **too old and obviously obsolete** — there is no realistic path back, and keeping the source adds no value.

Typical reasons:

- Targets a long-dead DSM release or architecture that is no longer built.
- Depends on a removed runtime/toolchain with no prospect of return (e.g. long-standing Python 2 packages).
- Abandoned upstream years ago with no users and no maintainer.

These packages are **deleted from the repository**. On the package site, their previously published builds are flagged **archived**: existing users keep what they installed, but nothing new is produced and the source no longer lives in git.

### How to retire

1. Confirm the package meets the "too old and obviously obsolete" bar (ideally already `BROKEN` for a while, or clearly dead).
2. Remove `spk/<package>/` (and any `cross/`, `diyspk/`, or `native/` parts that exist only for it) in a pull request that explains the rationale.
3. The package is marked **archived** on the site.

Because git history preserves the deletion, a retired package can still be recovered from history if it ever needs to be revived — but that is a deliberate re-introduction, not a simple toggle.

## Choosing between the two

- **Not sure, or potentially revivable, or upstream just changed?** → **Disable** (`BROKEN`). It is cheap, reversible, and keeps the work.
- **Clearly obsolete, ancient, and unwanted?** → **Retire** (remove + archive).

When in doubt, prefer disabling first; retire later once it is clearly obsolete.

## See also

- [Development Process](development-process.md)
- [Pull Requests](pull-requests.md)
