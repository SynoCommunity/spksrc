# AI Agent Instructions for spksrc

> **Using an assistant on spksrc? Start here.** This file is the short form: conventions,
> framework specifics and the mistakes that are easy to make in this repository. The `docs/`
> tree is the primary reference and is linked throughout. If your assistant does not read a
> root `AGENTS.md` on its own, tell it to. See
> [Working with an AI Assistant](https://docs.synocommunity.com/contributing/development-process/#working-with-an-ai-assistant).

This file provides guidance for AI coding assistants working with the spksrc repository.

## Overview

spksrc is a cross-compilation framework for building Synology NAS packages (SPK files).
The codebase uses GNU Make extensively with custom Makefile includes under `mk/`.

## Key Principles

1. **Don't push to GitHub without explicit user approval** - Always ask before pushing commits (each push triggers a CI run).
2. **Test builds before committing** - Build for a representative architecture, e.g. `make arch-x64-7.1`.
3. **Preserve existing patterns** - Follow conventions from similar packages in the repo.
4. **Patches must apply cleanly** - No fuzz or offset warnings.
5. **Simplicity over cleverness** - If a simpler solution works for all cases, prefer it over complex conditionals.
6. **Declare requirements, don't enumerate archs** - Prefer a capability floor (e.g. `MIN_GCC_VERSION`) over hand-maintained architecture lists; the framework then picks the right toolchain and excludes what cannot satisfy it.
7. **Always rebase against master before merging** - Keep branch history clean.

## Directory Conventions

- `cross/` - Libraries and applications cross-compiled for the target architecture (patches live in `cross/<pkg>/patches/`).
- `diyspk/` - Do-it-yourself SPK templates for standalone versions of bundled packages.
- `spk/` - Final SPK package definitions that users install.
- `native/` - Tools built for the host system (used during cross-compilation).
- `mk/` - Framework Makefiles (avoid modifying unless necessary; `mk/spksrc.build/`, `mk/spksrc.native/`, `mk/spksrc.common/` hold the sub-includes).
- `toolchain/` - Synology toolchain definitions (rarely modified).
- `kernel/` - Synology-modified kernel sources for building modules.

## Common Operations

### Building a Package
```bash
make setup                 # Initial setup (creates local.mk) - run once
cd spk/packagename
make arch-x64-7.1  # Build for a specific architecture: make arch-<arch>-<dsm>
make all-supported # Build all supported architectures
make clean         # Clean build artifacts
```

### Build Steps and Cookies
Each build step (download, checksum, patch, configure, compile, install, plist, ...)
is guarded by a cookie file `$(WORK_DIR)/.<pkg>-<step>_done`. A step re-runs only when
its cookie is absent.
- To redo a single step, delete its cookie (e.g. `rm work-*/.<pkg>-configure_done`) and re-`make`.
- `make <pkg>clean` (in `spk/`) resets the SPK's own cookies; **`make nativeclean`** (in `native/`)
  resets only the master native package's cookies, leaving its dependencies' cookies intact.

### Updating Package Version
1. Edit `PKG_VERS` in `cross/packagename/Makefile`.
2. Run `make digests` to refresh checksums (it also downloads the source first when no download cookie exists).
3. Edit `SPK_VERS` in `spk/packagename/Makefile`, increment `SPK_REV`.
4. Update `CHANGELOG`.
5. Test with `make arch-x64-7.1`.

For major version upgrades, check upstream release notes for breaking changes, dependency
compatibility, and migration requirements.

### Creating Patches
- Use unified diff format (`diff -u`).
- Name sequentially: `001-description.patch`, `002-another.patch`.
- Place arch-specific patches in `patches/archname/` subdirectory.
- Patches apply with `-p0` (no directory prefix stripping).

## Versioning Rules

- `SPK_REV` starts at 1, increments for packaging changes.
- Never reset `SPK_REV` - always increment, even when `SPK_VERS` changes.
- Never decrement version numbers.
- Bump against the **published** revision at <https://synocommunity.com/packages>, not
  against whatever is in the tree.
- `CHANGELOG` is recapitulative since the last release, not a log of one PR. With more than
  one item, number them so it stays readable: `CHANGELOG += "1. ...<br/>"`.
- When `SPK_VERS` is unchanged, **add to** the existing entries; replace them only on a real
  upstream version change.
- Omit dependency updates unless they are significant to the user; describe behaviour, not
  internals ("Internal build options now follow toolchain capabilities" rather than a
  variable name).

## Key Learnings

### Digests File Format
The digests file contains THREE checksums per file (SHA1, SHA256, MD5), not just SHA256.
When the saved filename differs from the remote one, set `PKG_DIST_FILE` (local saved name,
which the digests reference) distinct from `PKG_DIST_NAME` (remote filename) - useful when a
source (e.g. a GitLab/GitHub archive) serves a generic or awkward filename.

### Source Downloads and Mirrors
`PKG_DOWNLOAD_METHOD` selects how the source is fetched: unset (plain HTTP, the default and
what nearly every package wants), or `git` / `svn` / `hg`, which build the tarball locally
from `PKG_GIT_HASH` / `PKG_SVN_REV` / `PKG_HG_REV`. **Mirroring applies to HTTP only.**

`mk/spksrc.build/download.mk` provides built-in mirror fallback for well-known hosts via
seven `MIRROR_<FAMILY>` tables - `MIRROR_GNU`, `MIRROR_SOURCEFORGE`, `MIRROR_GNOME`,
`MIRROR_KERNEL`, `MIRROR_SAVANNAH`, `MIRROR_GNUPG`, `MIRROR_FREEDESKTOP` - each `?=`, so
`local.mk` can override any of them. When `PKG_DIST_SITE` matches such a host the mirrors
are tried automatically. Six are path-preserving (the family's tree-root marker is replaced);
`MIRROR_FREEDESKTOP` is the exception, appending only the file name, which is why its bases
embed `$(PKG_NAME)`.

For per-package fallbacks, set `PKG_DIST_MIRRORS` to a list of base URLs; `PKG_DIST_NAME` is
appended to each, so the mirror must serve that exact file name. Every candidate is still
checked against `digests`. Prefer a reliable primary source (upstream release/tag archives)
over fragile ad-hoc hosts; when no mirror serves the right name, upload to the SynoCommunity
`sources` release and point `PKG_DIST_MIRRORS` there. See
`docs/developer-guide/packaging/makefile-variables.md` (Source downloads and mirrors).

### PLIST Regeneration
For complex packages (Erlang-based, large dependency trees), PLIST may need regeneration
from actual build output when library versions change.

### Toolchain Differences
The compiler shipped with each DSM toolchain (authoritative values in `toolchain/syno-<arch>-<dsm>/Makefile`, `TC_GCC`):
- DSM 7.2 → GCC 12.x (x64)
- DSM 7.1 → GCC 8.5
- DSM 6.2.4 → GCC 4.9.3 (ARMv5/88f6281 uses GCC 4.6.4)
- DSM 6.x → GCC 4.x
- DSM 5.2 → GCC 4.3-4.6

Practical consequences:
- Gate compiler-dependent features on the **selected** compiler: `$(call version_ge,$(TC_GCC),4.9)`.
  `TC_GCC` is the effective compiler for the current build.
- Older GCC defaults to an older C standard (e.g. gcc 4.x → gnu89); pin `-std=gnu99`/`-Dc_std=gnu99`
  when a source uses C99 constructs and fails on legacy archs.
- ARMv5/88f6281 (GCC 4.6.4) does not support `-std=c11` - use `-std=gnu99`.
- Atomic support varies by architecture (some require libatomic linking).
- When a flag works across all toolchains, use it universally rather than complex conditionals.
- Use arch-specific patches in `patches/archname/` for toolchain-specific source fixes.

### An Arch List Standing In For a Capability Will Drift
This is the most common recurring defect in package Makefiles. A list written to mean
"the archs whose gcc is too old" is correct the day it is written and silently wrong
afterwards, because it names *where* a package fails rather than *why*. It cannot express
the condition, so an arch that meets it is missed for good.

Three examples from one file, `spk/borgbackup`, each missing `x86-5.2` for the same reason:

```makefile
-ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS)),)   # meant: gcc < 4.8
+ifeq ($(call version_lt,$(TC_GCC),4.8),1)

-ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))             # meant: rustc < 1.85
+ifeq ($(call version_ge,$(TC_RUSTC),1.85),1)

-UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)                            # meant: gcc < 4.6
+MIN_GCC_VERSION = 4.6
```

When you find such a list, work out the real threshold and *measure* it rather than
guessing: the toolchains are in tree and can be asked directly.

### Toolchain-Wide Link Libraries
`TC_EXTRA_LDFLAGS` already carries `-lrt` (glibc < 2.17, `clock_gettime`) and `-latomic`
(targets without native 64-bit atomics), the latter dropped where the gcc does not ship it.
**A package must not re-declare them.** They are passed plainly, not wrapped in
`-Wl,--as-needed`: `LDFLAGS` precedes the objects on every link line, and `--as-needed`
keeps a library only if it resolves a symbol that is *already* undefined at that point, so
a bracketed library there is always discarded. If you see a per-package
`--extra-ldflags="-lrt"` or equivalent, it is a workaround for that and can go.

### Package Folder vs `SPK_NAME`
CI keys its build matrix on the **directory name**, not `SPK_NAME` (`SPK_FOLDER` in
`mk/spksrc.rules/pre-check.mk`). A few packages differ - `spk/ffmpeg4` is `SPK_NAME = ffmpeg`,
`spk/mkvtoolnix_22` is `mkvtoolnix`, `spk/mono_58` is `mono` - and `SPK_NAME` is the DSM
package identity written into `INFO`, so it cannot be renamed without breaking upgrades.
Refer to a package by its folder in anything CI-facing.

### Build Logs
`RUNLOG` (the facade) and `_runlog` (the shell fragment it is built on) in
`mk/spksrc.common/macros.mk` do the teeing; `LOG_WRAPPED` no longer exists. Teeing happens
in `arch-%`, one level *above* the make that fails, so a pre-check refusal, make's own
`*** ... Stop.` and the exit cascade all reach `build-<arch>.log`. An error can only be
captured one level above the make that fails, so the outermost `make: *** [arch-...] Error 2`
is structurally unreachable. Per-package logs stay per package: an `spk/` dependency built
through `spk-meta` writes to its own `LOG_DIR`, by design.

### Build Arguments
Separate arguments by build phase rather than overloading one variable:
`CONFIGURE_ARGS` (also forwarded to `meson setup`), `COMPILE_ARGS`, `INSTALL_ARGS`, and
`ADDITIONAL_CFLAGS`/`ADDITIONAL_LDFLAGS` for flags. `BUILD_DIR` selects an out-of-tree build
directory. See `docs/developer-guide/packaging/makefile-variables.md` (Build Configuration).

### Conditionals Need the Common Includes First
Arch groups (`ARMv5_ARCHS`, ...), `version_ge`, and `TC_GCC` are defined by the framework
includes. Put `include ../../mk/spksrc.common.mk` (or the relevant `spksrc.cross-*.mk`)
**before** any `ifeq`/`$(call ...)` that uses them, or they expand empty.

### Dependencies and Optional Dependencies
- `DEPENDS` builds unconditionally; gate a dependency the current toolchain/arch cannot
  satisfy with an `ifeq`/`version_ge`/arch guard so it is simply not selected there
  (e.g. `ifeq ($(call version_ge,$(TC_GCC),4.8),1)`), rather than letting its cross build
  hard-fail and abort the consumer.
- `OPTIONAL_DEPENDS` is the *declared universe* of optional dependencies. It does not build
  per architecture; instead it drives two things: dependency-tree/CI package selection, and
  the GitHub Actions **prepare phase pre-download** of those sources. Keep an optional
  dependency listed there even when a per-arch `DEPENDS +=` guard excludes it, so its source
  is still fetched.

### Native Archive Helper and `nativeclean`
`mk/spksrc.native/archive.mk` packages a prebuilt tree into a release archive via
`ARCHIVE_DIR` / `ARCHIVE_KEEP` (guarded by the `.<pkg>-archive_done` cookie). Use this to
publish large host tools (e.g. gcc, llvm) as prebuilt archives instead of rebuilding in CI.
`make nativeclean` resets only the master native package's own step cookies.

### Python Multi-Version Support
- Python wheels have four types: pure-python, crossenv, abi3-limited, and cross-package.
- Pin all wheel versions exactly (e.g. `mercurial==6.5.1`); never include setuptools/pip/wheel.
- See `docs/developer-guide/package-types/python.md` and `.github/copilot-instructions.md`
  for detailed Python package patterns.

### Icon Requirements
Icons should be 512x512 pixels; the framework scales down automatically.

## Architecture Groups

Defined in `mk/spksrc.common/archs.mk` (authoritative). Commonly used:
- `x64_ARCHS` - Intel/AMD 64-bit
- `ARMv8_ARCHS` - ARM 64-bit (aarch64)
- `ARMv7_ARCHS` - ARM 32-bit
- `ARMv7L_ARCHS` - Legacy ARM 32-bit (hi3535)
- `ARMv5_ARCHS` - Legacy ARM (88f6281) - GCC 4.6.4, limited C standard support
- `PPC_ARCHS` - PowerPC (qoriq, ppc853x, etc.)
- `OLD_PPC_ARCHS` - Legacy PowerPC (DSM 5.2)
- `32bit_ARCHS` / `64bit_ARCHS` - width-based groups
- `SUPPORTED_ARCHS` / `LATEST_ARCHS` - policy groups

Prefer a capability floor over listing archs by hand; use `UNSUPPORTED_ARCHS` only to
exclude specific archs/families for a reason that is not a capability. The floors are
`MIN_GCC_VERSION`, `MIN_GLIBC_VERSION`, `MIN_RUSTC_VERSION` and `REQUIRE_64BIT`
(`mk/spksrc.common/tc-capability.mk` is authoritative). A floor may be set after
`include ../../mk/spksrc.common.mk`; pre-check reads it later.

`MIN_RUSTC_VERSION` compares against `TC_RUSTC`, which is *derived* rather than declared:
an arch whose Rust overlay is active reports the version that overlay pins, every other arch
reports `stable`, which sorts above any number and clears any floor.

## Git Workflow

- **Always work in feature branches** - never commit directly to master.
- **One working directory per PR** keeps concurrent branches isolated and identifiable.
- Branch naming: `packagename-version` or `fix-issue-description` (no `/` in branch names).
- **Never push without explicit approval** - always ask first (each push = one CI run); batch related edits into one commit rather than many.
- **Work through a PR opened upstream, and keep it a draft until it is green.** Create with
  `gh pr create --draft`, then `gh pr ready <N>` once every job passes and it is fit for
  review. This is not etiquette, it is what the CI is wired for
  (`.github/workflows/build.yml`):
    - **Draft cancels its own superseded runs.** A draft PR shares one concurrency group
      (`build-<workflow>-<ref>`) with `cancel-in-progress: true`, so each push kills the
      build the previous one started. A non-draft PR gets a unique per-run group with
      `cancel-in-progress: false`: nothing is cancelled, and iterative pushes pile up and
      queue behind each other.
    - **Draft avoids the duplicate fork build.** A push to your own fork normally starts its
      own narrower build; that one is skipped while the branch has an open *draft* PR
      upstream, because the authoritative build already runs on the PR. Not a draft, and you
      pay for both.
    - Marking it ready is therefore the last step, not the first — and if you must push
      afterwards, expect to cancel superseded runs by hand (`gh run cancel <id>`).
- **Rebase, then force-push your own PR branch** - a rebased branch requires `--force-with-lease`; only rewrite history on branches you own.
- **Always rebase against master before merging** - keep branch history clean.
- `git rebase -i` can be driven non-interactively by agents with `GIT_SEQUENCE_EDITOR=true`/`GIT_EDITOR=true`;
  for a heavy reorg, `git reset --soft <merge-base>` then re-commit the net diff by theme (the resulting tree is guaranteed identical).
- Editing a PR's title/body: `gh pr edit` can fail on a GitHub "Projects (classic)" GraphQL
  deprecation; fall back to `gh api -X PATCH repos/<owner>/<repo>/pulls/<N> -f title=... -F body=@file`.
- Configured user: check `git config user.name` and `git config user.email`.

### Commit Messages
- Use the `DISPLAY_NAME:` prefix from `spk/*/Makefile` (e.g. `Borg: Use gnu99 for GCC < 5.0`).
- Use `Framework:` prefix for `mk/` changes (not a filename prefix).
- Keep messages concise but descriptive.
- Keep commit messages in sync with the PR title/description.

## Code Style

- **Keep related items separated but simple** - e.g. each wheel's CFLAGS in its own block, but don't nest conditionals unnecessarily.
- **Remove redundant code** - don't leave dead code paths.
- **Check existing patterns first** - look at how similar packages solve the same problem before inventing new approaches.
- **Question necessity** - before making framework changes, verify they're truly required by comparing working vs failing cases.
- **Keep comments short** - one or two lines; explain *why*, not what the code already says.
- **Verify a probe before trusting it.** A throwaway makefile that sets a variable *after*
  `include ../../mk/spksrc.common.mk` is too late for anything `tc-capability.mk` computes
  at include time, and testing `$(if $(PLIST_TRANSFORM),...)` is always true because the
  default is `cat`. Prefer running the real target in the real directory.
- **Ask the toolchain rather than tabulate.** Compiler behaviour is testable: the toolchains
  are in tree, and `toolchain/syno-<arch>-<dsm>/work/*/bin/*-gcc` can be invoked directly to
  settle "which version accepts this flag" in seconds.

## CI/Build Failures

- **A green run proves nothing about a package that was not in it.** CI derives the package
  list from the changed files; read the `arch_packages` output of the prepare job
  (`ARCH_PACKAGES` in the build step) before concluding anything, because a package can be
  absent entirely and the run still be green.
- **DSM 5.2 is opt-in.** `.github/workflows/build.yml` adds `x86-5.2`, `88f6281-5.2` and
  `ppc853x-5.2` to the matrix only when the `add_dsm52_builds` input is true, which defaults
  to false. A change that only matters on the oldest toolchains is therefore not exercised
  by default. Turning it on for one run is legitimate; revert it with a *commit* rather than
  by rewriting history, so the run stays attached to the PR.
- Analyze CI logs carefully rather than guessing at fixes.
- Compare working vs failing builds to isolate differences (a green build before a change proves the change is the cause).
- Check if the issue is arch-specific (toolchain version, available libraries, C standard).
- Upload CI logs for review when debugging complex failures.
- Local builds may differ from CI (e.g. pre-existing work directories affect dependency resolution; delete stale cookies).
- Updating widely-used dependencies (zlib, openssl) triggers many package rebuilds - isolate in separate PRs.

## Detailed Documentation

The `docs/` tree is the primary, up-to-date reference:
- `docs/framework/` - architecture, `makefile-system.md`, `toolchain.md`, `toolkit.md`, and `changes.md` (framework changelog).
- `docs/developer-guide/packaging/makefile-variables.md` - the variables reference (identification, mirrors, build config, capability floors, arch groups, version conditions).
- `docs/developer-guide/packaging/build-rules.md` and `docs/developer-guide/basics/build-workflow.md` - build steps and cookies.
- `docs/developer-guide/package-types/` - per-type patterns (Python, etc.).
- `docs/contributing/` - `pull-requests.md`, `package-lifecycle.md`, `development-process.md`.
- `.github/copilot-instructions.md` - comprehensive build-system notes.
