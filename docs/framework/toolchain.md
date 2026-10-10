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
TC_SYSROOT  = $(TC_PREFIX)/x86_64-pc-linux-gnu/sysroot
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
set(CMAKE_SYSROOT /path/to/sysroot)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
```

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

An overlay is a toolchain component installed **beside** a base toolchain instead of
replacing it: a newer compiler, assembler/linker or Rust for a toolchain whose own is too
old. The base toolchain stays as Synology shipped it; an overlay only adds to it, and the
build decides which one it uses.

| Component | Version | Where | What for |
|-----------|---------|-------|----------|
| gcc | 8.5 | 65 toolchains: DSM 5.2 (4), 6.2.4 (31), 7.0 (28), 7.1 (2) | packages whose `MIN_GCC_VERSION` the vendor gcc does not meet |
| binutils | 2.30 | the same 65 | the `as`/`ld` gcc 8.5 needs -- the vendor ones cannot assemble what it emits |
| rust | 1.82, 1.98 | `x86-5.2`, `ppc853x-5.2`, `88f6281-5.2`, `88f6281-6.2.4`, `qoriq-6.2.4` | archs `rustup` ships no usable `rust-std` for (see below) |

### Producer, archive, consumer

Each overlay is built once, published as an archive, and downloaded by every build that
uses it -- nothing recompiles a compiler in CI.

| Piece | Role |
|-------|------|
| `native/gcc-8.5/`, `native/binutils-2.30/`, `native/rustc-<vers>/` | **Producer** -- builds the `.txz` for one `(arch, DSM)`, through `mk/spksrc.native-toolchain.mk` |
| `overlay/syno-<arch>-<dsm>_<component>-<vers>/` | **Consumer** -- downloads and extracts that `.txz` into its own `work/` |
| `toolchain/syno-<arch>-<dsm>/` | **Base toolchain** -- `DEPENDS` on the consumers it has, and points its `tc_vars` at the active ones |

A consumer is four lines; the directory name says the rest -- arch, DSM, component and, for
rust, the gcc it was built with (`_rust-1.98_gcc-8.5`):

```makefile
PKG_VERS = 8.5.0
PKG_REV  = v5

include ../../mk/spksrc.overlay.mk
```

`mk/spksrc.overlay.mk` reads the directory name and includes the component's own file from
`mk/spksrc.overlay/` (`gcc.mk`, `binutils.mk`, `rust.mk`). An arch has an overlay exactly when
such a directory exists for it in `overlay/`: adding one is adding the directory and its
`digests`.

Each consumer extracts into its **own** `work/`, never into the base toolchain's. That is
what lets two builds of a component sit side by side -- only the generated pointers decide
which one is used. `make clean` on a base toolchain cleans its consumers too, so a rebuild
re-extracts them.

**Generic archs share an archive.** `x64`, `armv7` and `aarch64` declare several `TC_ARCH`
and reuse a real arch's toolchain (the same `TC_DIST`). Their overlay is that arch's as
well: `x64-6.2.4` downloads `x86-6.2.4`'s archive, `x64-7.1` `apollolake-7.1`'s. Producer
and consumer derive the name from the same helper (`mk/spksrc.overlay/dist-arch.mk`), so
the name published is the name fetched.

### Overlay switches

Every overlay decision is resolved in one place, `mk/spksrc.common/overlay.mk`, read by the
toolchain and the package side alike. It keeps three questions apart:

| | Variable | Meaning |
|---|---|---|
| Available | `TC_OVERLAY_<c>` | the consumer dir, empty when the arch ships none |
| Requested | `OVERLAY_<c>` | the switch |
| Active | `OVERLAY_<c>_ON` | both of the above |

| Switch | Default | Effect |
|--------|---------|--------|
| `OVERLAY_GCC` | `1` | gcc 8.5 beside the vendor gcc, selected by its version suffix (`<target>-gcc-8.5`). Brings the binutils overlay with it. `TC_GCC` then reports `8.5.0`, so `MIN_GCC_VERSION` gates and `version_ge` selections follow the compiler actually used. |
| `OVERLAY_BINUTILS` | `0` | **Global**: overlay `as`/`ld` for *every* compile. Needs a matched modern gcc, hence off -- `OVERLAY_GCC` turns it on wherever the gcc overlay is active, and an explicit `OVERLAY_BINUTILS=0` there stops the build: for the vendor `as`/`ld`, set `OVERLAY_GCC=0` as well. |
| `OVERLAY_RUSTC` | `1` | Custom from-source rustc + Synology triple. `0` falls back to stock `rustup` -- diagnostic only: the archs that ship an overlay do so precisely because the stock std does not fit them. |
| `RUST_LINK_VIA_BINUTILS` | `1` where a rust overlay exists | **Narrow**: only the Rust link takes the overlay `ld`; C keeps the toolchain's `as`/`ld`. |
| `OVERLAY_GCC_VERS` | `8.5` | Which build to select, matching the consumer dir name. |
| `OVERLAY_BINUTILS_VERS` | `2.30` | Idem. |
| `OVERLAY_RUSTC_VERS` | newest the arch ships | Idem, among the rust builds made with the selected gcc -- the vendor-gcc ones when `OVERLAY_GCC` is off. |

The gcc overlay is on by default, tree-wide. It is inert where an arch ships none, which
is every toolchain whose vendor gcc is already recent. `x64-7.1` keeps one even though its
vendor gcc is 8.5.0 too: the overlay build is profile-guided, and on the most built arch
that saves roughly 15-25% of build time.

The switches are booleans: `1 y yes true on` and `0 n no false off`, in any case. Anything
else stops the build with `invalid boolean value` rather than reading as off (see
[Boolean values](../reference/macros.md#boolean-values)).

`make setup` writes `OVERLAY_RUSTC` and `OVERLAY_BINUTILS` into `local.mk`, the tree-wide
source of truth. It is read *before* `mk/spksrc.common/overlay.mk` and uses `?=`, which
gives:

    command line  >  environment  >  local.mk  >  the defaults above

Note the `?=`: a plain `=` in `local.mk` would win over an environment prefix, silently
ignoring the one-off override below.

```bash
OVERLAY_GCC=0 make -C cross/zlib arch-x64-6.2.4   # just this build, on the vendor gcc
```

A compiler choice holds for a package *and its whole dependency tree*: C++ built by a
vendor gcc older than 5 does not link with C++ built by gcc 8.5, whose library ABI differs. The switches cross every sub-make as
command-line variables (`FWRD_VARS`), which outrank a dependency's own `OVERLAY_x = ...`.
They are not carried across an spk boundary (`FWRD_ARGS_SPK`): a meta package decides for
itself, from the same defaults.

A request that cannot be honored degrades to the stock tools and says so, in a banner on the
`tcvars` path (the switches are a per-package choice, and the
toolchain's own `_all` is skipped once its cookie exists). You get one for binutils requested
where the arch ships none, one for a version it does not have, one for a gcc overlay with
no binutils beside it, one for the global binutils overlay driving a vendor gcc it is not
matched to, and one when the rust built with the gcc overlay is missing and the vendor-gcc
one is used instead.

One request stops the build instead: `OVERLAY_BINUTILS=0`, asked on the command line or in
the environment, for an arch whose gcc overlay is active. It cannot be obeyed -- gcc 8.5
drives `as`/`ld` through the binutils overlay -- and building anyway would let you believe
it was. A banner says so, and suggests `OVERLAY_GCC=0` for the vendor toolchain. The
`OVERLAY_BINUTILS ?= 0` that `make setup` writes into `local.mk` is a default, not a
request, and never triggers it.

Each generated `tc_vars.mk` records what the build actually resolved to:

```makefile
TC_OVERLAY_RUSTC := …/overlay/syno-qoriq-6.2.4_rust-1.98_gcc-8.5
TC_OVERLAY_BINUTILS := …/overlay/syno-qoriq-6.2.4_binutils-2.30
```

Both carry **active** semantics -- the path when that overlay drives the build, empty
otherwise. The narrow rust-link use shows up instead as a `-Clink-arg=-B<shim>` in the
Rust link flags. Tools are reached through `$(call tc,<tool>)`, which takes the active
overlay's `gcc` or `ld` and the base toolchain's otherwise (see
[Toolchain tools](../reference/macros.md#toolchain-tools)).

### Building and publishing an overlay

```bash
make -C native/gcc-8.5 arch-qoriq-6.2.4                    # one (arch, DSM): build, then archive
make -C native/gcc-8.5 TOOLCHAIN_JOBS=4 all-6.2.4          # every arch with a consumer, four at a time
make -C native/binutils-2.30 TOOLCHAIN_PGO=0 arch-x86-5.2  # one plain pass instead of two
make -C native/rustc-1.98 all-5.2
```

A generic arch is built as the real arch whose archive it fetches: `arch-x64-6.2.4` builds
`x86-6.2.4`, `arch-x64-7.1` builds `apollolake-7.1`. `all-<dsm>` builds every arch that has a
consumer of the component, each real arch once. An arch whose archive already exists is
skipped -- nothing to do -- so a batch stopped by a failure resumes where it stopped; remove
the `.txz` to rebuild one.

| Knob | Default | Effect |
|------|---------|--------|
| `TOOLCHAIN_PGO` | `1` for gcc and binutils | Two passes: build instrumented, run the instrumented tools over generated sources, rebuild reading the counts. The instrumented pass is never archived, so an archive that exists is always a finished build. |
| `TOOLCHAIN_JOBS` | `1` | Archs built in parallel by `all-<dsm>`, each still at full parallelism. |
| `TOOLCHAIN_KEEP_WORK` | `0` for gcc, else `1` | Keep each arch's work dir once its archive exists. A gcc tree is ~2 GB; a failed arch is always kept. |

The producer builds the component for the build host with `HOST_OPTFLAGS`: `-O2`, LTO,
and `-march=x86-64-v3` when the host compiler accepts it -- an archive built that way runs
only on an x86-64-v3 (AVX2) build host. gcc builds `native/binutils-2.30` for the same
`(arch, DSM)` first, and reads its target ABI (`--with-cpu`, float ABI, fpu) off the vendor
gcc of that toolchain.

The archive name carries a revision. When a rebuild changes what is inside without
changing a version already in the name, bump it, so caches never serve the stale file:

1. Bump `PKG_REV` in the producer (`native/<component>/Makefile`) and build.
2. Upload the `.txz` files to the release the consumers download from: `toolchains/dsm<dsm>`
   for gcc and binutils, `rust/qoriq` for rust.
3. Bump `PKG_REV` in the consumers and refresh their `digests`
   (`make -C overlay/syno-<arch>-<dsm>_<component>-<vers> digests`).

### Custom From-Source Rust Toolchains

A few legacy archs cannot use a stock `rustup` std: Tier-3 PowerPC e500 (`ppc853x`,
`qoriq`) has no prebuilt std at all, and ARMv5 `88f6281` / `x86-5.2` only ship one built
against a newer glibc than the DSM toolchain. For these, spksrc builds Rust **from source**
(rustc + cargo + host/target std, LLVM from the bundled source) against the arch's own gcc
-- or against the gcc 8.5 overlay, which rust 1.98 requires.

The Synology-vendored triple (`…-unknown-…` → `…-synology-…`) is derived from the central
arch map. Each arch ships a rust consumer per (rust, gcc) pair it was built for, and
`OVERLAY_RUSTC_VERS` picks among them. You do **not** build binutils separately for rust
either: the Rust build co-builds `native/binutils-2.30` for the same `(arch, DSM)` (gated on
`RUST_LINK_VIA_BINUTILS`); it is not a `DEPENDS`, which could not carry the per-arch
parametrization, so `make arch-<arch>-<dsm>` stays self-contained.

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
