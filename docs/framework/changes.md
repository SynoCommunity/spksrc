# Framework Changes

A curated log of notable changes to the spksrc **build framework** — the `mk/`
tree and the conventions every package Makefile relies on — newest first.

This is **not** an exhaustive changelog (for that, see `git log -- mk/`). Each
entry is collapsed to its date and title; expand it (▸) for what changed, why,
and a link to the pull request. Efforts that span several pull requests are a
single entry with the individual PRs nested inside.

---

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

??? note "July 1st 2026 — `spksrc.cross-virtual.mk` rename (#7251)"
    Renamed `spksrc.main-depends.mk` to describe what it is — the entry point for
    virtual (dependency-only) packages.

    Pull request: [#7251](https://github.com/SynoCommunity/spksrc/pull/7251)

??? note "June 28th 2026 — Reorganize `mk/` into functional submodules (#7237)"
    The flat `mk/` directory was reorganized into concern-based submodules
    (`spksrc.spk-meta/`, `spksrc.service/`, `spksrc.wheel/`, `spksrc.cross/`,
    `spksrc.native/`, `spksrc.build/`, …) so related logic lives together.

    Pull request: [#7237](https://github.com/SynoCommunity/spksrc/pull/7237)

??? note "June 28th 2026 — Boxed `*.mk` file headers (#7242)"
    Standardized every `*.mk` header to one boxed format, so each file states its
    purpose, inputs and outputs consistently.

    Pull request: [#7242](https://github.com/SynoCommunity/spksrc/pull/7242)

??? note "June 28th 2026 — `spksrc.cross-install.mk` rename (#7243)"
    Renamed `install-resources.mk` and slimmed the install wrappers so the
    cross/native install paths share one implementation.

    Pull request: [#7243](https://github.com/SynoCommunity/spksrc/pull/7243)

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
    dependencies (`version_ge TC_GCC …`) parse correctly on a cold tree.

    Pull request: [#7184](https://github.com/SynoCommunity/spksrc/pull/7184)
