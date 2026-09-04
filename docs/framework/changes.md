# Framework Changes

A curated log of notable changes to the spksrc **build framework** — the `mk/`
tree and the conventions every package Makefile relies on — newest first.

This is **not** an exhaustive changelog (for that, see `git log -- mk/`). Each
entry is collapsed to its date and title; expand it (▸) for what changed, why,
and a link to the pull request. Efforts that span several pull requests are a
single entry with the individual PRs nested inside.

## Highlights — the short version

If you only read one thing, read this. The details are in the dated log below.

- **`make help` knows your package.** Run it inside any package directory for a
  context-aware list of the targets and variables that actually apply there:

    ```bash
    cd cross/curl && make help
    ```

- **Declare what a package needs, not where it fails.** Instead of
  hand-maintaining an `UNSUPPORTED_ARCHS` list, state the capability floor:
  **`MIN_GCC_VERSION`**, **`MIN_GLIBC_VERSION`**, **`REQUIRE_64BIT`**. The
  framework refuses exactly the architectures whose toolchain cannot meet it,
  with a human-readable reason, and the gate stays correct on its own as
  toolchains move. See
  [Architecture Support](../developer-guide/packaging/makefile-variables.md#architecture-support).

- **Every build system uses the same variable names now.** CMake no longer has
  its own `CMAKE_ARGS`: pass configure options through **`CONFIGURE_ARGS`** for
  autotools, CMake *and* Meson alike. Compile and install options are likewise
  unified on **`COMPILE_ARGS`** and **`INSTALL_ARGS`** (the old
  `COMPILE_MAKE_OPTIONS` / `INSTALL_MAKE_OPTIONS` are gone). See
  [Build System Selection](../developer-guide/packaging/makefile-variables.md#build-system-selection)
  and
  [Compile and Install Arguments](../developer-guide/packaging/makefile-variables.md#compile-and-install-arguments).

- **A build directory is one variable.** `CMAKE_BUILD_DIR` / `MESON_BUILD_DIR` /
  `NINJA_BUILD_DIR` are unified on **`BUILD_DIR`**, which also opts an autotools
  package into an out-of-tree build.

- **Flaky download host? Add a mirror.** Set **`PKG_DIST_MIRRORS`** to one or
  more fallback base URLs; each is tried in turn and still checked against
  `digests`. See
  [Source downloads and mirrors](../developer-guide/packaging/makefile-variables.md#source-downloads-and-mirrors).

- **`include ../../mk/spksrc.common.mk` before any macro call.** The
  `version_*` macros (and friends) are only defined once `spksrc.common.mk` is
  included, so a Makefile must include it **before** the first `version_ge`,
  `version_lt`, … it uses.

- **Turning a package off? Prefer `DISABLED` over `BROKEN`.** A `DISABLED` file
  in a package folder skips it exactly like `BROKEN`, but reads as an
  intentional choice rather than a failure. Put the reason in the file. See the
  [package lifecycle](../contributing/package-lifecycle.md) guide.

- **The target ABI reaches every language now.** A toolchain declares its ABI
  once in **`TC_EXTRA_BUILD_FLAGS`**; the framework folds it into every
  `TC_EXTRA_<LANG>FLAGS` and the link, so C, C++, Fortran and the linker all
  agree on the ABI. Link-time libraries (`-lrt`, `-latomic`) live in
  **`TC_EXTRA_LDFLAGS`** and are passed plainly, with `-latomic` auto-dropped
  where the gcc lacks it. They are *not* wrapped in `--as-needed`: `LDFLAGS`
  precedes the objects, so a front-placed library there resolves nothing yet and
  the wrap discarded it outright.
  See [Extra flags a toolchain can declare](../framework/toolchain.md#extra-flags-a-toolchain-can-declare).

- **Build a host tool once, host it, reuse it.** A native package hosts its build
  output as a release archive with a single line — **`ARCHIVE_NAME`** — so an
  expensive tool (llvm, the gcc-8.5 overlays) is built once and pulled in via
  `DEPENDS` instead of rebuilt from source. **`make nativeclean`** drops a native
  package's build cookies to re-run it from scratch, the native counterpart of
  `spkclean`.

- **Rust builds on the legacy archs, and overlays are a first-class notion.** The archs
  `rustup` has no usable `rust-std` for — PowerPC e500 (`qoriq`, `ppc853x`), ARMv5
  `88f6281`, `x86-5.2` — now get a Rust toolchain built from source, published as an
  archive and pulled in like any other dependency. That fixes long-standing failures on
  those archs (SPE float, the ppc853x TLS relocations, `AtomicU64`). It also
  generalises: a component shipped **beside** a base toolchain is an *overlay*, switched
  with **`OVERLAY_RUSTC`** / **`OVERLAY_BINUTILS`** from `local.mk`, and `make help`
  shows which are active for your arch.

---

??? note "September 4th 2026 — Link librt and libatomic instead of discarding them (#7433)"
    - **What:** `TC_EXTRA_LDFLAGS` no longer wraps `-lrt` / `-latomic` in
      `-Wl,--as-needed ... -Wl,--no-as-needed`:

        ```makefile
        TC_EXTRA_LDFLAGS = $(TC_EXTRA_BUILD_FLAGS) $(_tc_ld_syslibs)
        ```

    - **Why:** `--as-needed` keeps a library only if it resolves a symbol that is
      *already* undefined when the linker reaches it. `LDFLAGS` is placed **before**
      the objects and libraries being linked, so nothing is undefined yet and the
      bracketed `-lrt` was dropped every time. The declaration introduced by #7314
      was therefore inert — measurably identical to declaring nothing:

        ```
        -Wl,--as-needed -lrt -Wl,--no-as-needed ... -lsrt
            -> undefined reference to `clock_gettime'
        (nothing declared at all)              ... -lsrt
            -> undefined reference to `clock_gettime'
        -lrt                                   ... -lsrt
            -> links, DT_NEEDED librt
        ```

    - **How it surfaced:** on glibc &lt; 2.17 toolchains (`ppc853x-5.2`,
      `88f6281-5.2`, `88f6281-6.1`), `libsrt.so` calls `clock_gettime` without
      declaring it. ffmpeg reported the resulting link failure as
      `ERROR: srt >= 1.3.0 not found using pkg-config`, which reads as a missing
      dependency rather than a missing library.
    - **Package-facing:** the five per-package workarounds it forced are gone —
      `cross/ffmpeg4` through `cross/ffmpeg8` each carried

        ```makefile
        ifeq ($(call version_lt,$(TC_GLIBC),2.17),1)
        CONFIGURE_ARGS += --extra-ldflags="-lrt"
        endif
        ```

      to put back what the toolchain had already declared. A package should not have
      to re-declare a toolchain library; if you have such a workaround, drop it.
    - **Cost:** one `DT_NEEDED` entry on binaries that never call into `librt` or
      `libatomic`. Both are part of the toolchain's own runtime and present on every
      target that ships them.
    - **Also in this PR:** `dependency-list` now keys its output on the package
      **folder** instead of `$(NAME)`. Three packages set `SPK_NAME` to something
      else — `spk/ffmpeg4` (`ffmpeg`), `spk/mkvtoolnix_22` (`mkvtoolnix`),
      `spk/mono_58` (`mono`) — while every consumer of the list already looked the
      key up as a directory (`.github/actions/prepare.sh`, `spk-meta/base.mk`). The
      three silently fell out of the CI build matrix, and the latter two collided
      with the `mkvtoolnix` / `mono` folders that still exist beside them. This is
      the rule `SPK_FOLDER` already states in `spksrc.rules/pre-check.mk`. The
      hand-maintained fixup list in `prepare.sh` (`nzbdrone -> sonarr3`,
      `python -> python2`, both stale) is removed with it.
    - Documented in
      [Extra flags a toolchain can declare](../framework/toolchain.md#extra-flags-a-toolchain-can-declare).
    - Pull request: [#7433](https://github.com/SynoCommunity/spksrc/pull/7433)

??? note "August 17th 2026 — Custom from-source Rust toolchains, and the overlay family (#7353)"
    - **What:** the archs `rustup` ships no usable prebuilt `rust-std` for now build
      Rust **from source** — `native/rustc-1.82` produces a `rust-<id>-<rev>.txz`, a
      per-arch consumer under `toolchain/syno-<arch>-<dsm>_rust-<vers>_gcc-<gcc>/`
      downloads it, and the base toolchain pulls that in through `DEPENDS`. Tier-3
      PowerPC e500 (`qoriq`, `ppc853x`) has no prebuilt std at all; ARMv5 `88f6281` and
      `x86-5.2` only ship one built against a newer glibc than DSM provides.
    - **Why it matters beyond Rust:** it introduces the **`OVERLAY_<component>`** family
      — a component shipped *beside* a base toolchain rather than replacing it. Rust and
      binutils 2.30 are the first two; a gcc-8.5 overlay is the next. Every decision is
      resolved once, in `mk/spksrc.common/overlay.mk`, which keeps three questions
      apart: *available* (`TC_OVERLAY_<c>` — the consumer dir), *requested*
      (`OVERLAY_<c>`), *active* (`OVERLAY_<c>_ON`). Conflating them is what produced the
      bugs this split now prevents.
    - **Switches**, written to `local.mk` by `make setup` and overridable per build:

        ```bash
        OVERLAY_BINUTILS=1 make -C cross/bat-0.25 arch-qoriq-6.2.4
        ```

        with precedence `command line > environment > local.mk > defaults`. A request
        that cannot be honored degrades to the stock tools and says so in a banner
        rather than failing. `make help` in `cross/`, `spk/` and `diyspk/` prints the
        switches, the value in effect, and what it resolves to for your arch.
    - **Arch issues fixed along the way:** per-target rustflags, so the PowerPC SPE
      codegen options actually reach the compiler (`-Ctarget-cpu=e500
      -Ctarget-feature=+spe`, not `+efpu2`) — the qoriq `bat`/`lsd` SIGILL of #7304; the
      ppc853x TLS/PIE relocations, by routing only the Rust link through binutils 2.30
      while C keeps the vendor `as`/`ld`; and `AtomicU64` on 32-bit, by widening the
      target spec wherever the arch's gcc ships `libatomic` (which unblocked `helix` on
      qoriq).
    - Package-facing: nothing changes on a standard arch. On a legacy one, a package
      that needs a newer toolchain than these pin should say so with `MIN_RUSTC_VERSION`
      / `MIN_GLIBC_VERSION` rather than an arch list. See [Toolchain: custom from-source
      Rust](toolchain.md#custom-from-source-rust-toolchains).
    - **Choosing instead of refusing:** a floor refuses an arch, but the `cross/<pkg>`
      virtuals have to pick a version of themselves instead. `TC_RUSTC` is now published
      beside `TC_GCC` / `TC_GLIBC` / `TC_KERNEL` — the rustc a toolchain pins, or
      `stable` when it uses rustup's newest — so a virtual routes with
      `$(call version_ge,$(TC_RUSTC),<vers>)`. `cross/bat`, `cross/ripgrep`, `cross/lsd`
      and `cross/eza` moved off `$(ARMv5_ARCHS) $(PPC_ARCHS)`, which had been standing in
      for "pinned to rustc 1.82" and so silently missed `x86-5.2`, a fourth arch this PR
      pins. `cross/helix` likewise replaced its ARMv7L exclusion with
      `MIN_GCC_VERSION = 4.9`: its C++ tree-sitter grammars build with `-std=c++14`,
      which g++ rejects before 4.9. Same story for the `$(OLD_PPC_ARCHS)` exclusions on
      the rust packages, which already named their reason in a comment: `cross/bat` and
      `cross/fd` reach `pipe2` through a dependency crate, so they declare
      `MIN_GLIBC_VERSION = 2.9`; `cross/ripgrep`'s pcre2 wants `-std=c11`, so
      `MIN_GCC_VERSION = 4.6`. Those lists read "except qoriq" while `qoriq-5.2` runs the
      same glibc 2.8 and gcc 4.3.7 as `ppc853x`, so the floors refuse an arch the lists
      let through. `cross/sd` and `cross/eza` lose their exclusion outright: their only
      blocker was std's own `pthread_setname_np`, which the weak-link patch above
      resolves, and both are confirmed building and running on ppc853x (@hgy59) — so
      `synocli-file` ships them there.
    - Pull request: [#7353](https://github.com/SynoCommunity/spksrc/pull/7353)

??? note "July 24th 2026 — Host a native build's output as a reusable archive (#7327, #7386)"
    - **What:** a new opt-in step, `spksrc.build/archive.mk` (included by
      `spksrc.native-cc.mk`), tars a native package's install tree into a release
      archive after `install`, so an expensive tool is built once and re-consumed
      via `DEPENDS` instead of rebuilt from source. A package enables it with a
      single line:

        ```makefile
        ARCHIVE_NAME = native-$(PKG_NAME)-$(PKG_VERS)
        ```

      The rest defaults — `ARCHIVE_EXT` (`txz`, mapped to the tar compression like
      `extract.mk` does in reverse), `ARCHIVE_DIR` (`$(WORK_DIR)`) and `ARCHIVE_KEEP`
      (`./install`) — with an optional debug-symbol strip and `ARCHIVE_EXCLUDES`. It
      follows the usual `pre_/archive_target/post_` pattern (override `ARCHIVE_TARGET`,
      or set it to `nop`), runs automatically from `_all`, is a **no-op unless
      `ARCHIVE_NAME` is set**, and is guarded by a status cookie like every other step
      (`extract`, `compile`, ...) so it runs once per work dir. `print-archive-name`
      lets a generator resolve the name without building.
    - **Also:** `nativeclean`, the native counterpart of `spkclean`, drops the master
      package's build cookies so every step re-runs on the next make while keeping the
      work dir; and the variables carry no redundant `NATIVE_` prefix (`ARCHIVE_*`,
      matching `ARCHIVE_CMD` / `ARCHIVE_COOKIE`). The step just runs and lets `tar`
      fail if nothing was built, rather than pre-checking a sentinel.
    - **Why:** the archive step was open-coded per package (`native/llvm-14.0-build`
      carried its own `build-archive` recipe); this factors it into one shared,
      defaulted helper. `native/llvm-14.0-build` adopts it here; the gcc-8.5
      overlays reuse it in #7324.
    - **Relocated (#7386):** moved `spksrc.native/archive.mk` →
      `spksrc.build/archive.mk` — the helper is a shared build step, not native-only
      (a from-source rustc reuses it in #7353). No behaviour change.
    - Pull requests: [#7327](https://github.com/SynoCommunity/spksrc/pull/7327),
      [#7386](https://github.com/SynoCommunity/spksrc/pull/7386)

??? note "July 23rd 2026 — Carry the runtime library the binary asks for, by symbol version (#7322)"
    - **What:** the strip step copies the runtime libraries DSM does not ship
      (`libatomic`, `libquadmath`, `libgfortran` -- the `TC_LIBS_DEFAULT` list) from
      the toolchain. It now selects the copy whose **symbol versions** satisfy the
      binary (`readelf -V` vs `strings`), instead of the first one a plain
      `find -name` turns up.
    - **Why:** a find by name returns every copy in the toolchain at once (the
      sysroot's, the compiler's `lib64`, a multilib) and handed the first to a
      `basename` expecting one. Choosing by symbol version is correct with the
      multilib case today and ready for several gcc versions to coexist under a
      future overlay.
    - No package-facing change.
    - Pull request: [#7322](https://github.com/SynoCommunity/spksrc/pull/7322)

??? note "July 23rd 2026 — Detect Fortran by probing the compiler (#7321)"
    - **What:** `TC_HAS_FORTRAN` was a static "7.x / SRM 1.3 / 6.2.4-x64 ship
      gfortran" table; it is now a probe of the actual `gfortran` binary, evaluated
      (like `TC_HAS_LIBATOMIC`) in the tc_vars sub-make after the toolchain is
      extracted, so cross packages read the baked result.
    - **Why:** the table is a proxy for the stock toolchains only -- it cannot see a
      compiler swapped in underneath, e.g. a gcc overlay that adds gfortran to an
      arch the table calls Fortran-less. Probing the binary stays correct whatever
      provides it, and gives the same answer as the table on every stock toolchain
      today.
    - No package-facing change.
    - Pull request: [#7321](https://github.com/SynoCommunity/spksrc/pull/7321)

??? note "July 23rd 2026 — Toolchain ABI and link flags reach every language (#7314)"
    A toolchain's ABI/arch flags now consistently reach every language and the
    link, and two link-time libraries stopped being hand-maintained arch lists.

    - **What:** a toolchain declares its ABI once in `TC_EXTRA_BUILD_FLAGS`
      (`-march`, `-mcpu`, `-mfpu`, `-mfloat-abi`, ...); the framework folds it into
      each `TC_EXTRA_<LANG>FLAGS` (C / CPP / C++ / Fortran) and into
      `TC_EXTRA_LDFLAGS`, so every language *and* the gcc link driver build with
      the same ABI. `-lrt` (glibc &lt; 2.17, `clock_gettime`) and `-latomic`
      (ARMv5 / PowerPC, no native 64-bit atomics) moved out of about two dozen
      per-package arch lists into `TC_EXTRA_LDFLAGS`; `-latomic` is kept only when
      the toolchain's gcc actually ships it, detected with
      `gcc -print-file-name=libatomic.so`. Both are wrapped in
      `-Wl,--as-needed ... -Wl,--no-as-needed` so, now that they are declared
      toolchain-wide, a binary records a `librt` / `libatomic` dependency only when
      it truly references one. **The wrap was removed in #7433** — see the
      September 4th 2026 entry: it discarded both libraries instead of pruning
      them.
    - **Why:** passing the ABI only through `CFLAGS` silently built C++ / Fortran
      objects with a different ABI than the C they link against, and the rt/atomic
      arch lists had to be rechecked by hand each time a toolchain moved.
      `TC_EXTRA_RUSTFLAGS` is left out on purpose — rustc takes its ABI through
      `-Ctarget-cpu`, and a crate's C dependencies get it via
      `CFLAGS_<target> = TC_EXTRA_CFLAGS`.
    - Documented in
      [Extra flags a toolchain can declare](../framework/toolchain.md#extra-flags-a-toolchain-can-declare).
    - Pull request: [#7314](https://github.com/SynoCommunity/spksrc/pull/7314)

??? note "July 23rd 2026 — Declare toolchain capabilities instead of arch lists (#7313)"
    A package can now say what it *needs* from a toolchain rather than list the
    architectures where it happens to fail today.

    - **What:** three declarative floors — `MIN_GCC_VERSION`, `MIN_GLIBC_VERSION`
      and `REQUIRE_64BIT` — checked against the toolchain's own `TC_GCC` /
      `TC_GLIBC` (and `TC_KERNEL`), now declared in each toolchain Makefile and
      read statically. An unmet floor makes `pre-check.mk` refuse that
      architecture with a human-readable reason, and several reasons accumulate
      (a 32-bit target on an old gcc reports both). About two dozen `cross/`
      packages and `ffmpeg7/8` dropped their `UNSUPPORTED_ARCHS` arch lists in
      favour of a floor.
    - **Why:** a hardcoded arch list says *where* a package fails, not *why*; it
      must be rechecked by hand every time a toolchain moves and cannot express
      "any arch whose gcc is older than X". A declared floor can, and stays
      correct on its own.
    - **Beyond a DSM floor:** `REQUIRED_MIN_DSM` was frequently used as a *proxy*
      for "needs a recent enough compiler", then topped up with `UNSUPPORTED_ARCHS`
      for the architectures a single DSM floor still missed — a DSM version does
      not map to one gcc across every arch, so an older platform can ship an older
      gcc on the same DSM. `MIN_GCC_VERSION` states the real requirement and covers
      all of those cases at once, dynamically. `REQUIRED_MIN_DSM` /
      `REQUIRED_MAX_DSM` / `REQUIRED_MIN_SRM` and `UNSUPPORTED_ARCHS` remain for
      genuine OS-version and per-arch constraints that are not a capability floor.
    - **Also:** `TC_GCC` is read from the toolchain Makefile instead of running
      `gcc -dumpversion`, so the compiler version is known before anything is
      extracted.
    - Documented in
      [Architecture Support](../developer-guide/packaging/makefile-variables.md#architecture-support).
    - Pull request: [#7313](https://github.com/SynoCommunity/spksrc/pull/7313)

??? note "July 13th 2026 — Build-variable standardization (3 PRs)"
    A three-part effort so that every build system (autotools, CMake, Meson)
    exposes the **same** package-facing variable names. Before it, a Makefile
    looked different depending on the underlying build tool; after it, the same
    variable means the same thing everywhere.

    ??? note "`CONFIGURE_ARGS` — unify the configure arguments (#7279)"
        CMake was the odd one out: it used `CMAKE_ARGS` / `ADDITIONAL_CMAKE_ARGS`
        while autotools and Meson already passed their options through
        `CONFIGURE_ARGS`.

        - **What:** renamed `CMAKE_ARGS` → `CONFIGURE_ARGS` and
          `ADDITIONAL_CMAKE_ARGS` → `ADDITIONAL_CONFIGURE_ARGS` across every cmake
          package (no alias); `ADDITIONAL_CONFIGURE_ARGS` is now honoured by
          autotools and Meson too.
        - **Why:** one variable for "arguments to the configure step" regardless
          of the build system. `ADDITIONAL_CONFIGURE_ARGS` remains for the rare
          case where a package reuses `CONFIGURE_ARGS` for its own auxiliary
          invocations and needs extra args to reach only the framework's call
          (see `cross/x265`).
        - Documented in
          [Build System Selection](../developer-guide/packaging/makefile-variables.md#build-system-selection).
        - Pull request: [#7279](https://github.com/SynoCommunity/spksrc/pull/7279)

    ??? note "`COMPILE_ARGS` / `INSTALL_ARGS` — unify the compile & install arguments (#7280)"
        The compile and install steps had an autotools-only slot
        (`COMPILE_MAKE_OPTIONS` / `INSTALL_MAKE_OPTIONS`) with no CMake/Meson
        equivalent.

        - **What:** introduced `COMPILE_ARGS` and `INSTALL_ARGS`. On the autotools
          / plain-make path they *are* the make command (replacing the removed
          `*_MAKE_OPTIONS`); for CMake and Meson they are appended as-is to
          `cmake --build` / `cmake --install` and `ninja` / `ninja install`.
        - **Defaults on the make path:** when unset, `COMPILE_ARGS` defaults to
          `-j$(NCPUS)` and `INSTALL_ARGS` to `install DESTDIR=… prefix=…`, so a
          package's own make routines can reference them and inherit sensible
          behaviour (e.g. `cross/cairo-1.16` gains `-j`; `cross/glibc-*` drop
          their explicit `-j`).
        - **Why the scoping matters:** the defaults are gated by `DEFAULT_ENV`
          (and an `INSTALL_TARGET` python check) so they never leak into
          CMake/Meson/rust/python builds — the native cmake/meson env files
          declare `DEFAULT_ENV` for the same reason.
        - Documented in
          [Compile and Install Arguments](../developer-guide/packaging/makefile-variables.md#compile-and-install-arguments).
        - Pull request: [#7280](https://github.com/SynoCommunity/spksrc/pull/7280)

    ??? note "`BUILD_DIR` — unify the build directory (#7282)"
        CMake, Meson and Ninja each had their own build-directory variable
        (`CMAKE_BUILD_DIR` / `MESON_BUILD_DIR` / `NINJA_BUILD_DIR`).

        - **What:** unified them on a single `BUILD_DIR`, set per build system by
          the matching env file, and **extended out-of-tree build support to the
          autotools / plain-make path**: it builds in-source by default and opts
          in to an out-of-tree build by setting `BUILD_DIR`.
        - **Why:** one name for "where the build happens", and a framework
          mechanism for out-of-tree autotools builds that packages previously
          hand-rolled — `cross/glibc` dropped its three custom
          configure/compile/install targets in favour of a one-line `BUILD_DIR`.
        - Pull request: [#7282](https://github.com/SynoCommunity/spksrc/pull/7282)

??? note "July 13th 2026 — Disable a package with `BROKEN` or `DISABLED` (#7283)"
    - **What:** a package is skipped when it has a `BROKEN` **or** a `DISABLED`
      file in its folder — both are honoured by `spksrc.rules/pre-check.mk`
      (build time) and the CI `prepare.sh` (package selection). Use `DISABLED`
      when a package is intentionally turned off and `BROKEN` when it is actually
      failing.
    - **Why:** the marker file now reads its intent. First use: `spk/ffmpeg{4,5,6}`
      were disabled — no new release is planned and disabling them keeps their
      large codec dependency trees out of the build. See the
      [package lifecycle](../contributing/package-lifecycle.md) guide.
    - Pull request: [#7283](https://github.com/SynoCommunity/spksrc/pull/7283)

??? note "July 2nd 2026 — Context-aware `make help` (#7250)"
    Context-aware help at the repo root and inside each package.

    Pull request: [#7250](https://github.com/SynoCommunity/spksrc/pull/7250)

??? note "July 2nd 2026 — Build logs off the repo root (#7256)"
    Build logs are no longer pinned to the repository root, keeping the tree clean.

    Pull request: [#7256](https://github.com/SynoCommunity/spksrc/pull/7256)

??? note "July 1st 2026 — Generic, bounded mirror fallback for downloads (#7254)"
    A download used to be a single request to `PKG_DIST_SITE`: if that host was
    down, or its TLS certificate had just expired, the build failed.

    - **What:** the download logic was split into per-method macros, and a
      download now walks a list of candidate URLs, stopping at the first success.
      Mirrors of the big source hosts (GNU, SourceForge, GNOME, X.Org,
      kernel.org) are tried automatically, and `PKG_DIST_MIRRORS` lets a package
      name its own fallback base URLs.
    - **Why bounded:** the candidate list is finite (primary URL + family mirrors
      + `PKG_DIST_MIRRORS`, de-duplicated) and each is retried `DOWNLOAD_TRIES`
      times, so a download that cannot succeed fails rather than looping.
    - **Why it is safe:** every candidate is checked against `digests`, so a
      mirror serving different bytes fails the build instead of poisoning it.
    - Documented in
      [Source downloads and mirrors](../developer-guide/packaging/makefile-variables.md#source-downloads-and-mirrors).
    - Pull request: [#7254](https://github.com/SynoCommunity/spksrc/pull/7254)

??? note "January 29th – July 1st 2026 — Reorganize `mk/` into functional submodules (8 PRs)"
    `mk/` was a flat pile of `spksrc.*.mk` files. Over six months it was
    reorganized so related logic lives together in concern-based submodules,
    while the entry-point files a package Makefile actually `include`s
    (`spksrc.cross-cc.mk`, `spksrc.spk.mk`, `spksrc.cross-cmake.mk`, …) stay at
    the root. This was not one big-bang move but a sequence of PRs, each carving
    out one concern at a time.

    Final layout:

    ```text
    mk/
    ├── spksrc.cross-cc.mk        ┐  entry points a Makefile includes
    ├── spksrc.cross-cmake.mk     │  stay at the root (unchanged include paths)
    ├── spksrc.spk.mk             ┘
    ├── spksrc.common/     archs, directories, macros, logs, stage0
    ├── spksrc.build/      per-step recipes: configure, compile, install, patch, …
    ├── spksrc.cross/      cross-build env per build system: cmake, meson, rust, go
    ├── spksrc.native/     native-build env per build system
    ├── spksrc.rules/      depend, dependency-tree, pre-check, digests, tests
    ├── spksrc.spk/        spk assembly: copy, icon, strip, publish
    ├── spksrc.spk-meta/   meta initiators: ffmpeg, python, videodriver
    ├── spksrc.service/    DSM service scripts and installers
    ├── spksrc.wheel/      python wheel build/install
    ├── spksrc.toolchain/  toolchain fetch + tc_vars generation
    ├── spksrc.toolkit/    build-host toolkit (mirrors toolchain)
    └── spksrc.kernel/     kernel-module build support
    ```

    ??? note "`spksrc.common/` — split `common.mk` (#6906)"
        Split the overloaded `spksrc.common.mk` into `spksrc.common/`
        (`archs.mk`, `macros.mk`, `logs.mk`, …) and had every `cross/` and `spk/`
        Makefile include `spksrc.common.mk` before any `version_*` macro call.

        Pull request: [#6906](https://github.com/SynoCommunity/spksrc/pull/6906)

    ??? note "`spksrc.toolchain/` (#6914)"
        Moved `spksrc.tc.mk` and the toolchain logic into `spksrc.toolchain/`
        (`tc-base.mk`, `tc-versions.mk`, `tc_vars.mk`, …).

        Pull request: [#6914](https://github.com/SynoCommunity/spksrc/pull/6914)

    ??? note "`spksrc.toolkit/` (#6973)"
        Reorganized the build-host toolkit the same way, mirroring the toolchain
        layout (`tk-base.mk`, `tk-versions.mk`, `tk_vars.mk`, …).

        Pull request: [#6973](https://github.com/SynoCommunity/spksrc/pull/6973)

    ??? note "`spksrc.kernel/` (#6994)"
        Split kernel-module support into `spksrc.kernel/` (`base.mk`,
        `headers.mk`, `module.mk`, `versions.mk`, …).

        Pull request: [#6994](https://github.com/SynoCommunity/spksrc/pull/6994)

    ??? note "`spksrc.spk-meta/` — meta initiators (#7008)"
        Split the ffmpeg / python / videodriver meta initiators out of the
        monolithic mk files into `spksrc.spk/` and `spksrc.spk-meta/`, and renamed
        the meta-spk initiator to `spksrc.spk-meta.mk`.

        Pull request: [#7008](https://github.com/SynoCommunity/spksrc/pull/7008)

    ??? note "The bulk: build / cross / native / rules / service / wheel (#7237)"
        The largest move: carved the remaining per-step recipes, per-build-system
        env files, rules, service scripts and wheel logic into
        `spksrc.build/`, `spksrc.cross/`, `spksrc.native/`, `spksrc.rules/`,
        `spksrc.service/` and `spksrc.wheel/`.

        Pull request: [#7237](https://github.com/SynoCommunity/spksrc/pull/7237)

    ??? note "`spksrc.cross-install.mk` rename (#7243)"
        Renamed `install-resources.mk` and slimmed the install wrappers so the
        cross/native install paths share one implementation.

        Pull request: [#7243](https://github.com/SynoCommunity/spksrc/pull/7243)

    ??? note "`spksrc.cross-virtual.mk` rename (#7251)"
        Renamed `spksrc.main-depends.mk` to describe what it is — the entry point
        for virtual (dependency-only) packages.

        Pull request: [#7251](https://github.com/SynoCommunity/spksrc/pull/7251)

??? note "June 28th 2026 — Boxed `*.mk` file headers (#7242)"
    Standardized every `*.mk` header to one boxed format, so each file states its
    purpose, inputs and outputs consistently.

    Pull request: [#7242](https://github.com/SynoCommunity/spksrc/pull/7242)

??? note "June 22nd–25th 2026 — Meta cross-dependency environment (4 PRs)"
    How a "meta" package (ffmpeg, videodriver, python) exposes its
    cross-dependencies to consumers.

    ??? note "Introduce the meta cross-dependency environment (#7222)"
        Introduced `META_PKGCONFIG_DIRS` + `tc_vars.meta.mk`.

        Pull request: [#7222](https://github.com/SynoCommunity/spksrc/pull/7222)

    ??? note "Resolve CMake meta deps via the toolchain file (#7223)"
        Resolve `OPENSSL_ROOT_DIR` + `CMAKE_FIND_ROOT_PATH` through the generated
        toolchain file instead of ad-hoc detection.

        Pull request: [#7223](https://github.com/SynoCommunity/spksrc/pull/7223)

    ??? note "Ordered `PKG_CONFIG_LIBDIR` shared across channels (#7228)"
        A single ordered pkg-config search path shared across all channels, so
        local staging reliably wins over meta directories.

        Pull request: [#7228](https://github.com/SynoCommunity/spksrc/pull/7228)

    ??? note "Meta mechanism rework (#7229)"
        Auto-build the meta source, drop the denylist, consolidate OpenSSL.

        Pull request: [#7229](https://github.com/SynoCommunity/spksrc/pull/7229)

??? note "June 10th 2026 — Toolchain cache poisoning fix (#7196)"
    A stale toolchain cache was silently dropping `TC_GCC`-gated `DEPENDS`.

    Pull request: [#7196](https://github.com/SynoCommunity/spksrc/pull/7196)

??? note "June 10th 2026 — Stage-0 toolchain bootstrap (#7184)"
    Bootstrap the toolchain before deriving `TC_GCC`, so version-gated
    dependencies (`version_ge TC_GCC …`) parse correctly on a cold tree. This
    refines the stage0 minimal environment introduced in March (see below).

    Pull request: [#7184](https://github.com/SynoCommunity/spksrc/pull/7184)

??? note "January – May 2026 — Faster, parallel dependency resolution (5 PRs)"
    Dependency resolution used to run through a shell script
    (`mk/dependency-list.sh`) walked serially. It is now a pure-Makefile
    implementation (`spksrc.rules/dependency-tree.mk`) that the framework can
    walk in parallel.

    ??? note "Faster `dependency-flat` (#6894)"
        Rewrote the flat dependency walk and fixed a basename collision in the
        parallel walk (packages of the same name in different directories, e.g.
        `native/erlang` and `cross/erlang`, shared a done-file).

        Pull request: [#6894](https://github.com/SynoCommunity/spksrc/pull/6894)

    ??? note "Pure-Makefile dependency-tree (#6952)"
        Replaced the legacy `dependency-list.sh` with
        `spksrc.dependency-tree.mk`, consolidating resolution into the framework
        and enabling parallel builds — up to ~2.9× faster.

        Pull request: [#6952](https://github.com/SynoCommunity/spksrc/pull/6952)

    ??? note "`EXCLUDE_DEPENDS` and `DEPENDS_TYPE` (#7028)"
        Added a way to prune a subtree from the traversal (`EXCLUDE_DEPENDS`) and
        to filter the output by relation type (`DEPENDS_TYPE`).

        Pull request: [#7028](https://github.com/SynoCommunity/spksrc/pull/7028)

    ??? note "Query a specific `ARCH` / `TCVERSION` (#7121, #7124)"
        Let the dependency tree be computed for a specific arch and DSM version,
        so version-gated dependencies resolve as they would in a real build.

        Pull requests: [#7121](https://github.com/SynoCommunity/spksrc/pull/7121),
        [#7124](https://github.com/SynoCommunity/spksrc/pull/7124)

??? note "April 19th – 22nd 2026 — Deduplicate applied patches (2 PRs)"
    - **What:** a patch listed both as an `arch` and as a `group` (armv7, x64
      could be both) was applied twice. `spksrc.build/patch.mk` now guarantees
      each patch appears once in `PATCHES`, with md5sum-based deduplication.
    - **Why:** applying a patch twice either fails or double-applies a hunk; the
      build should be independent of how a patch happened to be listed.
    - Pull requests: [#7098](https://github.com/SynoCommunity/spksrc/pull/7098),
      [#7104](https://github.com/SynoCommunity/spksrc/pull/7104)

??? note "April 5th – 7th 2026 — Standardize meta package variable names (4 PRs)"
    The ffmpeg, videodriver and python "meta" packages each exposed their install
    prefix under a differently-shaped variable name.

    - **What:** standardized the `*_INSTALL_PREFIX` variables —
      `VIDEODRV_*INSTALL_PREFIX` (#7043), `FFMPEG_*INSTALL_PREFIX` (#7044),
      `PYTHON_*INSTALL_PREFIX` (#7045) — and the surrounding python / openssl /
      ffmpeg / videodriver variable names (#7041).
    - **Why:** a consumer of any meta package now finds the same variable shape
      regardless of which one it depends on. This is the naming half of the meta
      cross-dependency environment (the June 22nd–25th entry above).
    - Pull requests: [#7041](https://github.com/SynoCommunity/spksrc/pull/7041),
      [#7043](https://github.com/SynoCommunity/spksrc/pull/7043),
      [#7044](https://github.com/SynoCommunity/spksrc/pull/7044),
      [#7045](https://github.com/SynoCommunity/spksrc/pull/7045)

??? note "March – April 2026 — stage0 minimal environment (3 PRs)"
    - **What:** `spksrc.common/stage0.mk` loads a minimal environment early —
      just enough for the `version_*` macros and `TC_GCC` — so a package Makefile
      can call `version_*` before the full toolchain environment exists (#7031),
      with a more robust `BASEDIR` detection (#7032) and a follow-up fix for a
      subtle ordering bug (#7078).
    - **Why:** it keeps the full toolchain environment from leaking into the
      dependency traversal, and lets version-gated `DEPENDS` parse on a cold
      tree. The stage-0 toolchain bootstrap (#7184, above) builds on this.
    - Pull requests: [#7031](https://github.com/SynoCommunity/spksrc/pull/7031),
      [#7032](https://github.com/SynoCommunity/spksrc/pull/7032),
      [#7078](https://github.com/SynoCommunity/spksrc/pull/7078)

??? note "February 7th 2026 — Multi-arch download orchestration (#6947)"
    Auto-orchestrate the download, checksum and digest steps across all of a
    package's distribution architectures, instead of handling one arch at a time.

    Pull request: [#6947](https://github.com/SynoCommunity/spksrc/pull/6947)
