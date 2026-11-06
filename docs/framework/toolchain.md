# Toolchain Management

This document describes how spksrc manages Synology cross-compilation toolchains.

## Overview

Synology provides official cross-compilation toolchains for each DSM version and architecture. spksrc downloads, extracts, and configures these toolchains automatically.

## Toolchain Directory Structure

```
toolchain/
├── syno-x64-7.2/
│   ├── Makefile
│   ├── digests
│   └── work/
│       └── x86_64-pc-linux-gnu/    # Extracted toolchain (nothing else)
├── syno-aarch64-7.2/
├── syno-armv7-7.2/
└── ...
```

## Toolchain Naming

Toolchains follow the pattern `syno-<arch>-<tcversion>`:

- **arch** - Target architecture (x64, aarch64, armv7, etc.)
- **tcversion** - DSM version (7.2, 7.1, 6.2.4, etc.)

Examples:
- `syno-x64-7.2` - Intel 64-bit for DSM 7.2
- `syno-aarch64-7.1` - ARM 64-bit for DSM 7.1
- `syno-armv7-6.2.4` - ARM 32-bit for DSM 6.2.4

## Toolchain Makefile

Each toolchain directory contains a Makefile with:

```makefile
TC_NAME  = x86_64-pc-linux-gnu
TC_VERS  = 7.2
TC_ARCH  = x64
TC_DIST_SITE_PATH = $(SYNOLOGY_DOWNLOAD_URL)/toolchain/DSM$(TC_VERS)
TC_DIST_NAME = $(TC_DIST_SITE_PATH)/Intel%20x86%20Linux%204.4.302%20%28x86_64-GPL%29.txz

include ../../mk/spksrc.toolchain.mk
```

`spksrc.toolchain.mk` is the entry point; its implementation under `mk/spksrc.toolchain/` is detailed in the [Makefile System include hierarchy](makefile-system.md#include-hierarchy). The matching DSM development toolkit is covered on the [Toolkit](toolkit.md) page.

### Extra flags a toolchain can declare

A toolchain Makefile may add flags that then apply to **every** package built
with it. Assembled by `mk/spksrc.toolchain/tc-flags.mk`:

| Variable | Purpose |
|----------|---------|
| `TC_EXTRA_BUILD_FLAGS` | The target's ABI / arch flags (`-march`, `-mcpu`, `-mfpu`, `-mfloat-abi`, `-mthumb`, ...) |
| `TC_EXTRA_CFLAGS` / `TC_EXTRA_CPPFLAGS` / `TC_EXTRA_CXXFLAGS` / `TC_EXTRA_FFLAGS` | Per-language extra flags |
| `TC_EXTRA_LDFLAGS` | Extra link-time flags / libraries (`-lrt`, `-latomic`) |
| `TC_EXTRA_RUSTFLAGS` | Extra rustc flags (`-Ctarget-cpu=...`) |

**`TC_EXTRA_BUILD_FLAGS` selects the ABI**, so it must reach *every* language and
the link — not just C. Building C++ or Fortran objects with a different ABI than
the C objects they link against yields silently broken binaries, and the gcc link
driver reads these flags to pick the right multilib and startfiles. The framework
therefore folds `TC_EXTRA_BUILD_FLAGS` once into each `TC_EXTRA_<LANG>FLAGS` (and
into `TC_EXTRA_LDFLAGS`). Each per-language variable is then the single residual
list that language reads — the ABI first, then anything the toolchain adds for
that language, always last in the chain, so it stays a clean place to extend. A
package's own `ADDITIONAL_<LANG>FLAGS` are separate and package-scoped.

`TC_EXTRA_RUSTFLAGS` is deliberately *not* fed from `TC_EXTRA_BUILD_FLAGS`: rustc
takes its ABI through `-Ctarget-cpu` (already in `TC_EXTRA_RUSTFLAGS`), and the C
dependencies of a rust crate receive the ABI through
`CFLAGS_<target> = TC_EXTRA_CFLAGS`.

**`TC_EXTRA_LDFLAGS` — `-lrt` vs `-latomic`, auto-detected.** Two link-time needs
were previously hand-carried as per-package architecture lists:

- `-lrt` — glibc &lt; 2.17 keeps `clock_gettime` in a separate `librt`.
- `-latomic` — targets without native 64-bit atomics (ARMv5, PowerPC e500v2) make
  gcc emit calls into `libatomic` that the link must resolve.

`-latomic` is kept only when the toolchain's gcc actually ships the library: the
framework asks `gcc -print-file-name=libatomic.so` (`TC_HAS_LIBATOMIC`) rather than
tabulating architectures. That is the exact criterion — a gcc old enough to lack
`libatomic` (before 4.7) also predates the `__atomic_*` builtins, emits `__sync_*`
instead, and so never needs the library — and handing `-latomic` to such a gcc is a
fatal *"cannot find -latomic"*. A toolchain lists `-latomic` in its
`TC_EXTRA_LDFLAGS`; the framework drops it where it would not resolve.

These libraries are declared toolchain-wide, so they reach every link even though
most binaries call neither `clock_gettime` nor an atomic builtin. They are
nonetheless passed **plainly**, not wrapped in `-Wl,--as-needed`.

`--as-needed` keeps a library only if, *at the point the linker sees it*, it
resolves an already-undefined symbol. `LDFLAGS` is placed **before** the objects
and libraries being linked, so at that point nothing is undefined yet: a
front-placed `-lrt` inside an `--as-needed` bracket is always discarded, and a
later `-lsrt` that needs `clock_gettime` then fails with *undefined reference*.
The wrap was therefore not a refinement of the declaration but a silent deletion
of it — exactly equivalent to declaring nothing at all.

Linking them plainly costs one `DT_NEEDED` entry on binaries that do not call
into them. That is the correct trade: `librt` and `libatomic` are part of the
toolchain's own runtime and are present on every target that has them.

## tc_vars Files

Several `tc_vars*.mk` files configure cross-compilation. They are generated into the **work
directory of the build tree that asked for them** — never into the toolchain, which is shared by
every tree and could only ever hold one tree's answer:

```
cross/libpng/work-x64-7.1/tc_vars.mk    # libpng AND the zlib it pulls in read this one
```

`WORK_DIR` carries that: `depend.mk` hands the root's value down through `$(ENV)`, and
`directories.mk` keeps what it is given (`ifndef`), so a dependency builds inside the root's work
directory. The `env -i` around an spk meta source is where one tree ends and the next begins.

Two builds may therefore run side by side against the same toolchain — two SPKs, or a cross
package built directly to test it — each with its own answer and no file to contend for.

### tc_vars.mk

Core toolchain identity:

```makefile
TC_NAME     = x86_64-pc-linux-gnu
TC_PREFIX   = /path/to/toolchain/work/x86_64-pc-linux-gnu/bin/
TC_PATH     = $(TC_PREFIX)/bin
TC_SYSROOT  = x86_64-pc-linux-gnu/sys-root
TC_CC       = $(TC_PREFIX)x86_64-pc-linux-gnu-gcc
TC_CXX      = $(TC_PREFIX)x86_64-pc-linux-gnu-g++
TC_AR       = $(TC_PREFIX)x86_64-pc-linux-gnu-ar
TC_LD       = $(TC_PREFIX)x86_64-pc-linux-gnu-ld
TC_STRIP    = $(TC_PREFIX)x86_64-pc-linux-gnu-strip
```

### tc_vars.autotools.mk

Autotools (configure) adapter:

```makefile
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --host=$(TC_NAME) --build=$(TC_BUILD)
```

### tc_vars.flags.mk

Compiler and linker flags:

```makefile
CFLAGS   = -I$(STAGING_INSTALL_PREFIX)/include
CXXFLAGS = $(CFLAGS)
LDFLAGS  = -L$(STAGING_INSTALL_PREFIX)/lib -Wl,-rpath,$(INSTALL_PREFIX)/lib
```

Each language's flags end with its own `TC_EXTRA_<LANG>FLAGS` — `CFLAGS` ends with
`TC_EXTRA_CFLAGS`, `CXXFLAGS` with `TC_EXTRA_CXXFLAGS`, and so on — and `LDFLAGS`
ends with `TC_EXTRA_LDFLAGS`. Each of those already carries the toolchain-declared
ABI (`TC_EXTRA_BUILD_FLAGS`, folded in as described under
[Extra flags a toolchain can declare](#extra-flags-a-toolchain-can-declare)), so
the ABI reaches every compiler *and* the link driver.

### tc_vars.cmake

CMake toolchain file for cross-compilation:

```cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_C_COMPILER /path/to/x86_64-pc-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER /path/to/x86_64-pc-linux-gnu-g++)
set(CMAKE_FIND_ROOT_PATH /path/to/work/install/usr/local)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
```

No `CMAKE_SYSROOT`: the compiler already knows its own. A package's generated toolchain
file then appends the meta staging roots and, last, the toolchain's sysroot to
`CMAKE_FIND_ROOT_PATH`, so `find_library`/`find_path` take what is built in the staging
first and still find what glibc itself provides (`m`, `c`, `sys/epoll.h`).

### tc_vars.meson-cross and tc_vars.meson-native

Meson cross and native files:

```ini
# tc_vars.meson-cross
[binaries]
c = '/path/to/x86_64-pc-linux-gnu-gcc'
cpp = '/path/to/x86_64-pc-linux-gnu-g++'
ar = '/path/to/x86_64-pc-linux-gnu-ar'
strip = '/path/to/x86_64-pc-linux-gnu-strip'
pkgconfig = '/usr/bin/pkg-config'

[host_machine]
system = 'linux'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'
```

### tc_vars.rust.mk

Rust cross-compilation settings:

```makefile
RUST_TARGET = x86_64-unknown-linux-gnu
RUSTFLAGS = -C linker=$(TC_CC)
```

## Supported Architectures

The complete list of architecture families, platform codenames, architecture groups (`ARM_ARCHS`, `x64_ARCHS`, `64bit_ARCHS`, ...) and the Synology models they map to is maintained in the reference:

- [Reference: Architectures](../reference/architectures.md)
- [Reference: Model ↔ Architecture](../reference/model-architecture.md)

## Adding New Toolchain Support

When Synology releases a new DSM version:

1. **Create toolchain directory**:
   ```bash
   mkdir toolchain/syno-x64-8.0
   ```

2. **Create Makefile**:
   ```makefile
   TC_NAME  = x86_64-pc-linux-gnu
   TC_VERS  = 8.0
   TC_ARCH  = x64
   TC_DIST_SITE_PATH = $(SYNOLOGY_DOWNLOAD_URL)/toolchain/DSM$(TC_VERS)
   TC_DIST_NAME = $(TC_DIST_SITE_PATH)/Intel%20x86%20Linux%20...%20%28x86_64-GPL%29.txz
   
   include ../../mk/spksrc.toolchain.mk
   ```

3. **Create digests file** with SHA256 checksums

4. **Test build**:
   ```bash
   make -C spk/transmission ARCH=x64 TCVERSION=8.0
   ```

## Toolchain Build Process

The toolchain build follows this process:

1. **Download** - Fetches toolchain archive from Synology
2. **Checksum** - Verifies archive integrity
3. **Extract** - Unpacks to `work/` directory
4. **Normalize** - Applies patches for compatibility
5. **Rust** - Installs Rust toolchain components if needed

The toolchain does not generate `tc_vars*`; the build tree does, into its own work directory.

## Caching

Toolchains are cached in the `distrib/` directory:

```
distrib/
└── toolchain/
    ├── Intel x86 Linux 4.4.302 (x86_64-GPL).txz
    ├── Realtek RTD1296 Linux 4.4.180 (aarch64-GPL).txz
    └── ...
```

Once downloaded, toolchains are reused across builds. Delete from `distrib/` to force re-download.

## Toolchain Overlays

An overlay is a toolchain component installed **beside** a base toolchain instead of replacing it: a newer compiler, assembler/linker or Rust for a toolchain whose own is too old or missing. The base toolchain stays as Synology shipped it -- glibc, kernel headers, sysroot -- so the binaries built keep running on stock DSM; an overlay only adds tools, and the build decides which ones it uses.

| Component | Versions | Toolchains | Used by builds |
|-----------|----------|------------|----------------|
| rust | 1.82 (vendor gcc), 1.82 and 1.98 (gcc 8.5) | `x86-5.2`, `ppc853x-5.2`, `88f6281-5.2`, `88f6281-6.2.4`, `qoriq-6.2.4` | the vendor-gcc build, see [Custom From-Source Rust Toolchains](#custom-from-source-rust-toolchains) |
| binutils | 2.30 | 65 toolchains of DSM 5.2 to 7.1 | for the Rust link of the five archs above (`RUST_LINK_VIA_BINUTILS`) |
| gcc | 8.5 | the same 65 | not yet: installed only |

### The overlay/ directories

Each overlay is a directory of `overlay/`, named `syno-<arch>-<dsm>_<component>-<version>` -- a rust one adds the gcc it was built with, `_rust-1.82_gcc-4.9.3`. Its Makefile is four lines; the directory name says the rest:

```makefile
PKG_VERS = 8.5.0
PKG_REV  = v5

include ../../mk/spksrc.overlay.mk
```

It downloads one archive into `distrib/overlay/<dsm>/`, as a toolchain does into `distrib/toolchain/<dsm>/`, and extracts it into its **own** `work/`, never the base toolchain's: that is what lets two builds of a component sit side by side, only the generated pointers deciding which one is used. A generic arch (`x64`, `armv7`, `aarch64`) downloads the archive of the real arch whose toolchain it shares -- `x64-6.2.4` that of `x86-6.2.4`, `x64-7.1` that of `apollolake-7.1` (`mk/spksrc.overlay/dist-arch.mk`).

An arch has an overlay exactly when such a directory exists for it: adding one is adding the directory and its `digests`.

### Installed and cleaned with the toolchain

A base toolchain (`toolchain/syno-<arch>-<dsm>/`) `DEPENDS` on every overlay of its arch (`TC_OVERLAY_ALL`), binutils first since the gcc overlay links its `as`/`ld` at install time, whether a build uses them or not. `make clean` on the base toolchain cleans them too, so a rebuild re-extracts them; `make dist-clean` at the top level runs `overlay-clean` over every one.

### Where the overlay code lives

Overlay code sits at four levels, by role, each read by a different Makefile:

| Level | Files | Read by | See |
|-------|-------|---------|-----|
| **Decide** | `mk/spksrc.common/overlay.mk` | every package and toolchain, through `spksrc.common.mk`: which overlays the arch has (`TC_OVERLAY_*`), which are requested (`OVERLAY_*`) and active (`OVERLAY_*_ON`), versions, warnings | [Overlay switches](#overlay-switches) |
| **Install** | `mk/spksrc.overlay.mk`, `mk/spksrc.overlay/<component>.mk`, `dist-arch.mk` | the Makefile of an `overlay/` directory: download, extract into its own `work/`, then the component's own step (binutils shim, gcc links, `rustup toolchain link`) | [The overlay/ directories](#the-overlay-directories) |
| **Use** | `mk/spksrc.toolchain/overlay-binutils.mk`, `overlay-rustc.mk` | the base toolchain, and the `tc_vars` it generates for packages: shim path and `-B`, Synology triple, rustup toolchain, Rust link flags; cleaning the overlays | [tc_vars Files](#tc_vars-files) |
| **Produce** | `native/rustc-<version>`, `native/binutils-2.30` | a maintainer, by hand: build an archive to publish | [Publishing an archive](#publishing-an-archive), [Building Rust](#building-rust) |

The base toolchain ties the first three together: it installs every overlay of its arch, and includes the *use* files, which point its builds at the active ones. The Makefiles themselves are listed in [Makefile System](makefile-system.md).

### Overlay switches

Every overlay decision is resolved in `mk/spksrc.common/overlay.mk` (the *decide* level above), read by the toolchain and the package side alike. It keeps three questions apart:

| | Variable | Meaning |
|---|---|---|
| Available | `TC_OVERLAY_<c>` | the consumer dir, empty when the arch ships none |
| Requested | `OVERLAY_<c>` | the switch |
| Active | `OVERLAY_<c>_ON` | both of the above |

| Switch | Default | Effect |
|--------|---------|--------|
| `OVERLAY_RUSTC` | `1` | Custom from-source rustc + Synology triple. `0` falls back to stock `rustup` — diagnostic only: the archs that ship an overlay do so precisely because the stock std does not fit them. |
| `OVERLAY_BINUTILS` | `0` | **Global**: overlay `as`/`ld` for *every* compile. Only safe under a matched modern gcc, hence off. |
| `RUST_LINK_VIA_BINUTILS` | `1` where a rust overlay exists | **Narrow**: only the Rust link takes the overlay `ld`; C keeps the vendor `as`/`ld`. |
| `OVERLAY_RUSTC_VERS` | `1.82` | Which build to select, matching the consumer dir name. |
| `OVERLAY_BINUTILS_VERS` | `2.30` | Idem. |

`make setup` writes the first two into `local.mk`, the tree-wide source of truth. It is read *before* `mk/spksrc.common/overlay.mk` and uses `?=`, which gives:

    command line  >  environment  >  local.mk  >  the defaults above

Note the `?=`: a plain `=` in `local.mk` would win over an environment prefix, silently ignoring the one-off override below.

```bash
OVERLAY_BINUTILS=1 make -C cross/bat-0.25 arch-qoriq-6.2.4   # just this build
```

A request that cannot be honored never fails the build: it degrades to the stock tools and says so, in a banner on the `tcvars` path (the switches are a per-package choice, and the toolchain's own `_all` is skipped once its cookie exists). You get one for a component the arch does not ship, one for a version it does not have, and one for the global overlay driving a vendor gcc it is not matched to.

Each generated `tc_vars.mk` records what the build actually resolved to:

```makefile
TC_OVERLAY_RUSTC := …/syno-qoriq-6.2.4_rust-1.82_gcc-4.9.3
TC_OVERLAY_BINUTILS :=          # empty: the narrow rust link only, not the global overlay
```

Both carry **active** semantics — the path when that overlay drives the build, empty otherwise. The narrow rust-link use shows up instead as a `-Clink-arg=-B<shim>` in the Rust link flags. The `OVERLAY_<c>` switches are deliberately not exported: a package includes `tc_vars.mk`, so it would inherit the previous run's choice and the switch would go sticky.

### Publishing an archive

The archives are published in releases: gcc and binutils in `toolchains/dsm<dsm>`, beside the toolchains they extend, and rust in `rust/qoriq`. The archive name carries a revision: when a rebuild changes what is inside without changing a version already in the name, bump it, so caches never serve the stale file.

1. Build the archive with its producer in `native/`, under the new revision (`PKG_REV=vN`).
2. Upload the `.txz` to its release.
3. Bump `PKG_REV = vN` in the overlay's Makefile and refresh its `digests` (`make -C overlay/syno-<arch>-<dsm>_<component>-<version> digests`).

## Custom From-Source Rust Toolchains

A few legacy archs cannot use a stock `rustup` std: Tier-3 PowerPC e500 (`ppc853x`, `qoriq`) has no prebuilt std at all, and ARMv5 `88f6281` / `x86-5.2` only ship one built against a newer glibc than the DSM toolchain. For these, spksrc builds Rust **from source** (rustc + cargo + host/target std, LLVM from the bundled source) against the arch's own gcc, and ships it as an overlay (see [Toolchain Overlays](#toolchain-overlays)).

An arch opts in simply by having a rust overlay (`TC_OVERLAY_RUSTC`); the Synology-vendored triple (`…-unknown-…` → `…-synology-…`) is derived from the central arch map. The C toolchain keeps its stock vendor `gcc`+`ld`; only the Rust link routes through the binutils 2.30 overlay (`RUST_LINK_VIA_BINUTILS`). The rust builds made with the gcc 8.5 overlay are installed beside the vendor one, and not selected.

### Building Rust

```bash
make -C native/rustc-1.82 arch-ppc853x-5.2  # one arch
make -C native/rustc-1.82 all-5.2          # every rust arch of a DSM version
```

You do **not** build binutils separately: the Rust build co-builds `native/binutils-2.30` for the same `(arch, DSM)` automatically (the `rustc_binutils_cobuild` step, gated on `RUST_LINK_VIA_BINUTILS`). It is intentionally not a `DEPENDS` -- a `DEPENDS` cannot carry the per-arch parametrization -- so `make arch-<arch>-<vers>` is self-contained. The build prints a `Co-building binutils …` banner when it does so. Publish the result as in [Publishing an archive](#publishing-an-archive).

## Troubleshooting

### Toolchain Download Fails

Check if the URL is still valid:
```bash
grep TC_DIST_NAME toolchain/syno-x64-7.2/Makefile
# Verify URL accessibility
```

### tc_vars Not Generated

They belong to the build tree, so remove them there and rebuild the package:
```bash
rm -f cross/<package>/work-x64-7.2/tc_vars* cross/<package>/work-x64-7.2/.stage1-tcvars_done
make -C cross/<package> arch-x64-7.2
```
`stage0` rewrites `tc_vars.mk` alone at parse time; `stage1` rewrites the whole set.

### Cross-Compiler Not Found

Ensure the toolchain is fully extracted:
```bash
ls toolchain/syno-x64-7.2/work/x86_64-pc-linux-gnu/bin/
```

## Related Documentation

- [Architecture](architecture.md) - Build pipeline overview
- [Makefile System](makefile-system.md) - mk/*.mk file details
- [Reference: Architectures](../reference/architectures.md) - Complete architecture reference
