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

Each file has its own role, and a build reads only those it needs (`TC_VARS_ENV`, set in
`mk/spksrc.cross/env-default.mk`): `tc_vars.mk` always, `tc_vars.autotools.mk` and
`tc_vars.flags.mk` for an autotools build, `tc_vars.rust.mk` for every package, since any of
them may build crates. CMake and Meson builds do not read the generic files directly: they get
a file of their own, generated per dependency (below).

The examples are those of `cross/zlib` for `qoriq-6.2.4`, shortened: `<spksrc>` is the
checkout, `<tc>` stands for `<spksrc>/toolchain/syno-qoriq-6.2.4/work/powerpc-e500v2-linux-gnuspe`.

| File | Holds | Read by |
|------|-------|---------|
| `tc_vars.mk` | the toolchain's identity and versions: no compiler, no flags | every build |
| `tc_vars.autotools.mk` | `TC_CONFIGURE_ARGS` and the environment of a cross build: `CC`, `CXX`, `AR`, `LD`, … and the `*FLAGS`, as `TC_ENV += …` | autotools builds |
| `tc_vars.flags.mk` | `CFLAGS`, `CPPFLAGS`, `CXXFLAGS`, `LDFLAGS` as make variables | autotools builds, and the CMake and Meson file generators |
| `tc_vars.rust.mk` | the cargo and rustup environment, per Rust target triple | every package |
| `tc_vars.cmake` | the toolchain half of a CMake toolchain file | the per-dependency CMake toolchain file |
| `tc_vars.meson-cross`, `tc_vars.meson-native` | the toolchain half of a Meson cross file, and the build machine's native file | the per-dependency Meson cross file |

### tc_vars.mk

What the toolchain is, as plain values: where it lives, its target and prefix, the ABI flags it
declares, and the versions the capability floors compare against (`MIN_GCC_VERSION`,
`MIN_KERNEL_VERSION`, …). The overlay pointers carry **active** semantics -- the path when that
overlay drives the build, empty otherwise (see [Toolchain Overlays](#toolchain-overlays)).

```makefile
TC_TYPE := DSM
TC_WORK_DIR := <spksrc>/toolchain/syno-qoriq-6.2.4/work
TC_SYSROOT := powerpc-e500v2-linux-gnuspe/sysroot
TC_TARGET := powerpc-e500v2-linux-gnuspe
TC_PREFIX := powerpc-e500v2-linux-gnuspe-
TC_PATH := <tc>/bin/
TC_INCLUDE := powerpc-e500v2-linux-gnuspe/sysroot/usr/include
TC_LIBRARY := powerpc-e500v2-linux-gnuspe/sysroot/lib
TC_EXTRA_BUILD_FLAGS := -mcpu=8548 -mhard-float -mfloat-gprs=double
TC_EXTRA_CFLAGS := -mcpu=8548 -mhard-float -mfloat-gprs=double
...                                  # TC_EXTRA_CPPFLAGS, CXXFLAGS, FFLAGS, LDFLAGS, RUSTFLAGS
TC_VERS := 6.2.4
TC_BUILD := 25556
TC_OS_MIN_VER := 6.2-25556
TC_ARCH := qoriq
TC_GCC := 4.9.3
TC_GLIBC := 2.20
TC_BINUTILS := 2.25
TC_OVERLAY_RUSTC := <spksrc>/overlay/syno-qoriq-6.2.4_rust-1.82_gcc-4.9.3
TC_OVERLAY_BINUTILS :=
TC_OVERLAY_BINUTILS_PATH :=
TC_KERNEL := 2.6.32
```

### tc_vars.autotools.mk

The configure arguments, and the whole environment an autotools build runs under: every tool
with its absolute path, the flags, and the `*_FOR_BUILD` set for what runs on the build machine.

```makefile
TC_CONFIGURE_ARGS := --host=powerpc-e500v2-linux-gnuspe --build=i686-pc-linux
TC_ENV += SYSROOT="<tc>/powerpc-e500v2-linux-gnuspe/sysroot"
TC_ENV += CC="<tc>/bin/powerpc-e500v2-linux-gnuspe-gcc"
TC_ENV += CXX="<tc>/bin/powerpc-e500v2-linux-gnuspe-g++"
TC_ENV += LD="<tc>/bin/powerpc-e500v2-linux-gnuspe-ld"
TC_ENV += LDSHARED="<tc>/bin/powerpc-e500v2-linux-gnuspe-gcc -shared"
...                                  # CPP, AS, AR, NM, RANLIB, STRIP, OBJDUMP, OBJCOPY, READELF
TC_ENV += CFLAGS="-I<tc>/…/sysroot/usr/include -I<spksrc>/cross/zlib/work-qoriq-6.2.4/install/usr/local/zlib/include …"
...                                  # CPPFLAGS, CXXFLAGS, LDFLAGS
TC_ENV += CC_FOR_BUILD="/usr/bin/gcc"
...                                  # CXX/CPP_FOR_BUILD and their flags
```

### tc_vars.flags.mk

The same flags as make variables, for the makefiles that compose with them:

```makefile
CFLAGS := -I<tc>/…/sysroot/usr/include -I<spksrc>/cross/zlib/work-qoriq-6.2.4/install/usr/local/zlib/include -mcpu=8548 …
CPPFLAGS := …
CXXFLAGS := …
LDFLAGS := -L<tc>/…/sysroot/lib -L<spksrc>/cross/zlib/work-qoriq-6.2.4/install/usr/local/zlib/lib -Wl,--rpath-link,… -Wl,--rpath,/usr/local/zlib/lib …
```

Each language's flags end with its own `TC_EXTRA_<LANG>FLAGS` — `CFLAGS` ends with
`TC_EXTRA_CFLAGS`, `CXXFLAGS` with `TC_EXTRA_CXXFLAGS`, and so on — and `LDFLAGS`
ends with `TC_EXTRA_LDFLAGS`. Each of those already carries the toolchain-declared
ABI (`TC_EXTRA_BUILD_FLAGS`, folded in as described under
[Extra flags a toolchain can declare](#extra-flags-a-toolchain-can-declare)), so
the ABI reaches every compiler *and* the link driver.

### tc_vars.rust.mk

What cargo, rustup and the crates that compile C (`cc-rs`) need: the rustup toolchain and target,
the linker, archiver and flags under the per-triple names cargo and `cc-rs` read, and the
`HOST_*` tools for build scripts. `RUST_TARGET`, `TC_RUSTC` and `TC_RUSTUP_TOOLCHAIN` come from
here too, so a package that calls cargo itself needs no rust mk of its own. On an arch with a
rust overlay, the toolchain is the overlay's and the target the Synology triple:

```makefile
TC_ENV += CARGO_HOME="<spksrc>/distrib/cargo"
TC_ENV += RUSTUP_HOME="<spksrc>/distrib/rustup"
TC_ENV += RUSTUP_TOOLCHAIN="1.82.0-powerpc-synology-linux-gnuspe-qoriq-6.2.4-gcc4.9.3"
TC_ENV += RUST_TARGET_PATH="<spksrc>/distrib/rustup/toolchains/1.82.0-…-gcc4.9.3/target-spec"
TC_ENV += CARGO_BUILD_TARGET="powerpc-synology-linux-gnuspe"
TC_ENV += CARGO_TARGET_POWERPC_SYNOLOGY_LINUX_GNUSPE_LINKER="<tc>/bin/powerpc-e500v2-linux-gnuspe-gcc"
TC_ENV += CARGO_TARGET_POWERPC_SYNOLOGY_LINUX_GNUSPE_AR="<tc>/bin/powerpc-e500v2-linux-gnuspe-ar"
TC_ENV += CARGO_TARGET_POWERPC_SYNOLOGY_LINUX_GNUSPE_RUSTFLAGS="-Clink-arg=-L… -Clink-arg=-B<spksrc>/overlay/syno-qoriq-6.2.4_binutils-2.30/work/shim …"
TC_ENV += CC_powerpc_synology_linux_gnuspe="<tc>/bin/powerpc-e500v2-linux-gnuspe-gcc"
...                                  # CXX_, AR_, RANLIB_, CFLAGS_, CXXFLAGS_<triple>
TC_ENV += HOST_CC="/usr/bin/gcc"
...                                  # HOST_CXX, HOST_AR, HOST_RANLIB and their flags
RUST_TARGET := powerpc-synology-linux-gnuspe
TC_RUSTC := 1.82.0
TC_RUSTUP_TOOLCHAIN := 1.82.0-powerpc-synology-linux-gnuspe-qoriq-6.2.4-gcc4.9.3
```

### tc_vars.cmake, and the CMake toolchain file of a dependency

`tc_vars.cmake` holds what is the same for every CMake package of the tree: the target system
and processor, the cross tools and their `*_FOR_BUILD` counterparts, the find-root modes, and the
Rust settings for CMake projects that build crates (Corrosion).

```cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ppc)
set(CMAKE_C_COMPILER          <tc>/bin/powerpc-e500v2-linux-gnuspe-gcc)
set(CMAKE_CXX_COMPILER        <tc>/bin/powerpc-e500v2-linux-gnuspe-g++)
set(CMAKE_AR                  <tc>/bin/powerpc-e500v2-linux-gnuspe-ar)
...                           # LINKER, AS, NM, RANLIB, STRIP, OBJDUMP, … and *_FOR_BUILD
set(CMAKE_FIND_ROOT_PATH <spksrc>/cross/zlib/work-qoriq-6.2.4/install/usr/local/zlib)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(RUST_TARGET  powerpc-synology-linux-gnuspe)
...
```

It is not handed to CMake as is. At configure time, each CMake dependency generates its own
toolchain file in its build directory, `$(BUILD_DIR)/<arch>-toolchain.cmake`
(`mk/spksrc.cross/cmake-toolchainfile.mk`): `tc_vars.cmake`, followed by what that package's
Makefile sets -- the `CMAKE_C_FLAGS`/`CMAKE_CXX_FLAGS` made of the tree's flags plus its
`ADDITIONAL_*FLAGS`, the linker flags, `BUILD_SHARED_LIBS`, the install rpath, the
`PKG_CONFIG_LIBDIR` of its dependencies, `OPENSSL_ROOT_DIR`, the meta packages' find roots, the
toolchain's sysroot, and the `RUSTFLAGS`. That file is the one passed as `-DCMAKE_TOOLCHAIN_FILE`.

No `CMAKE_SYSROOT`: the compiler already knows its own. The meta roots and then the sysroot are
appended to `CMAKE_FIND_ROOT_PATH`, so `find_library`/`find_path` take what is built in the
staging first and still find what glibc itself provides (`m`, `c`, `sys/epoll.h`).

Some sysroots hold more than glibc -- `libbfd` on most, `expat`, `uuid` and `bz2` on
ppc853x-5.2 -- so a package still declares every library it uses: an undeclared probe
can find the toolchain's copy instead of failing.

### tc_vars.meson-cross and tc_vars.meson-native, and the Meson cross file of a dependency

`tc_vars.meson-cross` holds the `[host_machine]` and `[binaries]` of the target, the same for
every Meson package of the tree; `tc_vars.meson-native` the `[binaries]` of the build machine.

```ini
# tc_vars.meson-cross
[host_machine]
system = 'linux'
cpu_family = 'ppc'
cpu = 'ppc'
endian = 'big'

[binaries]
c = '<tc>/bin/powerpc-e500v2-linux-gnuspe-gcc'
cpp = '<tc>/bin/powerpc-e500v2-linux-gnuspe-g++'
ar = '<tc>/bin/powerpc-e500v2-linux-gnuspe-ar'
...                                  # ld, as, nm, ranlib, strip, objdump, …, cargo, rust
```

As for CMake, each Meson dependency generates its own cross file at configure time,
`$(WORK_DIR)/$(PKG_DIR)/<arch>-crossfile.meson` (`mk/spksrc.cross/meson-crossfile.mk`):
`tc_vars.meson-cross`, plus `pkg-config` and, for a Python extension, the crossenv's `python`,
`cython` and `meson`, then its `[properties]` and `[built-in options]` -- `prefix`, and the
`c_args`, `cpp_args` and link args made of the tree's flags plus the package's `ADDITIONAL_*FLAGS`.
That file is the one passed as `--cross-file`.

## Supported Architectures

The complete list of architecture families, platform codenames, architecture groups (`ARM_ARCHS`, `x64_ARCHS`, `64bit_ARCHS`, ...) and the Synology models they map to is maintained in the reference:

- [Reference: Architectures](../reference/architectures.md)
- [Reference: Model ↔ Architecture](../reference/model-architecture.md)

## Adding New Toolchain Support

Synology publishes its toolchains on [archive.synology.com/download/ToolChain/toolchain](https://archive.synology.com/download/ToolChain/toolchain), one directory per DSM release (`<version>-<build>`, e.g. `7.2-72806`), with a subdirectory per platform. When Synology releases a new DSM version:

1. **Add the version** to `TC_VERSION_MAP` in `mk/spksrc.toolchain/tc-versions.mk`: its build number, `DSM` or `SRM`, and where its toolchains are downloaded from. The download URL is then built from it (`mk/spksrc.toolchain/tc-url.mk`): `https://global.synologydownload.com/download/ToolChain/toolchain/<version>-<build>/<TC_DIST_SITE_PATH>/<TC_DIST>.txz`.

2. **Create the toolchain directory**, one per platform, `toolchain/syno-<arch>-<version>/`, with a Makefile naming the archive and what it holds -- the archive name and its platform directory as Synology publishes them:
   ```makefile
   TC_ARCH = geminilake
   TC_VERS = 7.2
   TC_KERNEL = 4.4.302
   TC_GLIBC = 2.36
   TC_GCC = 12.2.0
   TC_BINUTILS = 2.38

   TC_DIST = geminilake-gcc1220_glibc236_x86_64-GPL
   TC_DIST_SITE_PATH = Intel%20x86%20Linux%204.4.302%20%28GeminiLake%29

   TC_TARGET = x86_64-pc-linux-gnu
   TC_SYSROOT = $(TC_TARGET)/sys-root

   include ../../mk/spksrc.toolchain.mk
   ```
   `TC_SYSROOT` is the sysroot its gcc reports (`<target>-gcc -print-sysroot`), relative to the
   extracted `$(TC_TARGET)`: a package's `tcvars` checks the two agree and stops when they do not.

3. **Create its `digests`**, three checksums of the archive -- SHA1, SHA256 and MD5 -- with `make -C toolchain/syno-<arch>-<version> digests`.

4. **Test a build**:
   ```bash
   make -C spk/transmission arch-geminilake-7.2
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

Toolchains and their [overlays](#toolchain-overlays) are cached in the `distrib/` directory, per DSM version:

```
distrib/
├── toolchain/
│   ├── 6.2.4/
│   │   ├── Intel x86 Linux 4.4.302 (x86_64-GPL).txz
│   │   └── ...
│   └── 7.1/
│       └── ...
└── overlay/
    ├── 6.2.4/
    │   ├── binutils-2.30-powerpc-e500v2-linux-gnuspe-qoriq-6.2.4-v4.txz
    │   ├── gcc-8.5.0-powerpc-e500v2-linux-gnuspe-qoriq-6.2.4-v5.txz
    │   ├── rust-1.98.1-powerpc-synology-linux-gnuspe-qoriq-6.2.4-gcc8.5-v1.txz
    │   └── ...
    └── 7.1/
        └── ...
```

Once downloaded, archives are reused across builds; delete one from `distrib/` to force its re-download. The archive name carries the revision of the build (`-v5`), so a new revision is downloaded beside the old one rather than over it, and the old one can be deleted by hand.

What is extracted is not under `distrib/`: a toolchain into `toolchain/syno-<arch>-<dsm>/work/`, each of its overlays into its own `overlay/syno-<arch>-<dsm>_<component>/work/`. `make clean` on the toolchain removes both, and the next build extracts them again from `distrib/` without downloading. The CI caches those `work/` directories as well, keyed on the `digests` of the toolchain and of its overlays: a new overlay revision, which changes its `digests`, invalidates the cache of its arch.

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

It downloads one archive into `distrib/overlay/<dsm>/`, as a toolchain does into `distrib/toolchain/<dsm>/`, and extracts it into its **own** `work/`, never the base toolchain's: that is what lets two builds of a component sit side by side, only the generated pointers deciding which one is used. A generic arch (`x64`, `armv7`, `aarch64`) downloads the archive of the real arch whose toolchain it shares -- `x64-6.2.4` that of `x86-6.2.4`, `x64-7.1` that of `apollolake-7.1` (`overlay_dist_arch`, `mk/spksrc.common/macros/archs.mk`).

An arch has an overlay exactly when such a directory exists for it: adding one is adding the directory and its `digests`.

### Installed and cleaned with the toolchain

A base toolchain (`toolchain/syno-<arch>-<dsm>/`) `DEPENDS` on every overlay of its arch (`TC_OVERLAY_ALL`), binutils first since the gcc overlay links its `as`/`ld` at install time, whether a build uses them or not. `make clean` on the base toolchain cleans them too, so a rebuild re-extracts them; `make dist-clean` at the top level runs `overlay-clean` over every one.

### Where the overlay code lives

Overlay code sits at four levels, by role, each read by a different Makefile:

| Level | Files | Read by | See |
|-------|-------|---------|-----|
| **Decide** | `mk/spksrc.common/overlay.mk`, `mk/spksrc.common/overlay/<component>.mk` | every package and toolchain, through `spksrc.common.mk`: which overlays the arch has (`TC_OVERLAY_*`), which are requested (`OVERLAY_*`) and active (`OVERLAY_*_ON`), versions, warnings | [Overlay switches](#overlay-switches) |
| **Install** | `mk/spksrc.overlay.mk`, `mk/spksrc.overlay/<component>.mk` | the Makefile of an `overlay/` directory: download, extract into its own `work/`, then the component's own step (binutils shim, gcc links, `rustup toolchain link`) | [The overlay/ directories](#the-overlay-directories) |
| **Use** | `mk/spksrc.toolchain/overlay/<component>.mk` | the base toolchain, and the `tc_vars` it generates for packages: shim path and `-B`, Synology triple, rustup toolchain, Rust link flags; cleaning the overlays | [tc_vars Files](#tc_vars-files) |
| **Produce** | `native/gcc-8.5`, `native/binutils-2.30`, `native/rustc-<version>`, through `mk/spksrc.native-toolchain.mk` | a maintainer, by hand: build an archive to publish | [Building and publishing an overlay](#building-and-publishing-an-overlay) |

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
| `OVERLAY_GCC` | `0` | gcc 8.5 beside the vendor gcc, with the binutils overlay it drives. Off for the tree; `native/rustc-1.98`, a rust built with gcc 8.5, turns it on for itself. |
| `OVERLAY_RUSTC` | `1` | Custom from-source rustc + Synology triple. `0` falls back to stock `rustup` — diagnostic only: the archs that ship an overlay do so precisely because the stock std does not fit them. |
| `OVERLAY_BINUTILS` | `0` | **Global**: overlay `as`/`ld` for *every* compile. Only safe under a matched modern gcc, hence off. |
| `RUST_LINK_VIA_BINUTILS` | `1` where a rust overlay exists | **Narrow**: only the Rust link takes the overlay `ld`; C keeps the vendor `as`/`ld`. |
| `OVERLAY_GCC_VERS` | `8.5` | Which gcc build to select, matching the consumer dir name. |
| `OVERLAY_RUSTC_VERS` | newest the arch ships | Which rust build to select, among those made with the selected gcc -- the vendor-gcc ones while `OVERLAY_GCC` is off. |
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

### Building and publishing an overlay

```bash
make -C native/gcc-8.5 arch-qoriq-6.2.4                    # one (arch, DSM): build, then archive
make -C native/gcc-8.5 TOOLCHAIN_JOBS=4 all-6.2.4          # every arch with an overlay, four at a time
make -C native/binutils-2.30 TOOLCHAIN_PGO=0 arch-x86-5.2  # one plain pass instead of two
make -C native/rustc-1.82 all-5.2
```

A producer is a version, a revision and a component name: `native/gcc-8.5`, `native/binutils-2.30` and `native/rustc-<version>` include `mk/spksrc.native-toolchain.mk`, which carries `arch-<arch>-<dsm>`, `all-<dsm>`, the host optimisation flags and the profile-guided passes, and dispatches to `mk/spksrc.native-toolchain/$(PKG_NAME).mk` (`gcc`, `binutils`, `rustc`).

A generic arch is built as the real arch whose archive it fetches: `arch-x64-6.2.4` builds `x86-6.2.4`, `arch-x64-7.1` builds `apollolake-7.1`. `all-<dsm>` builds every arch that has an overlay of the component, each real arch once. An arch whose archive already exists is skipped -- nothing to do -- so a batch stopped by a failure resumes where it stopped; remove the `.txz` to rebuild one. An archive is written under a temporary name and renamed once complete, so an interrupted build never leaves a truncated file under the final name.

| Knob | Default | Effect |
|------|---------|--------|
| `TOOLCHAIN_PGO` | `1` for gcc and binutils | Two passes: build instrumented, run the instrumented tools over generated sources -- C, C++ and, for gcc, Fortran (`toolchain-pgo-sources.sh`) -- rebuild reading the counts. The instrumented pass is never archived, so an archive that exists is always a finished build. |
| `TOOLCHAIN_JOBS` | `1` | Archs built in parallel by `all-<dsm>`, each still at full parallelism. |
| `TOOLCHAIN_KEEP_WORK` | `0` for gcc, else `1` | Keep each arch's work dir once its archive exists. A gcc tree is ~2 GB; a failed arch is always kept. |

The producer builds the component for the build host with `HOST_OPTFLAGS`: `-O2`, LTO, and `-march=x86-64-v3` when the host compiler accepts it -- an archive built that way runs only on an x86-64-v3 (AVX2) build host. gcc builds `native/binutils-2.30` for the same `(arch, DSM)` first, and reads its target ABI (`--with-cpu`, float ABI, fpu) off the vendor gcc of that toolchain.

The archives are published in releases: gcc and binutils in `toolchains/dsm<dsm>`, beside the toolchains they extend, and rust in `rust/qoriq`. The archive name carries a revision: when a rebuild changes what is inside without changing a version already in the name, bump it, so caches never serve the stale file.

1. Bump `PKG_REV` in the producer (`native/<component>/Makefile`) and build.
2. Upload the `.txz` to its release.
3. Bump `PKG_REV = vN` in the overlay's Makefile and refresh its `digests` (`make -C overlay/syno-<arch>-<dsm>_<component>-<version> digests`).

## Custom From-Source Rust Toolchains

A few legacy archs cannot use a stock `rustup` std: Tier-3 PowerPC e500 (`ppc853x`, `qoriq`) has no prebuilt std at all, and ARMv5 `88f6281` / `x86-5.2` only ship one built against a newer glibc than the DSM toolchain. For these, spksrc builds Rust **from source** (rustc + cargo + host/target std, LLVM from the bundled source) against the arch's own gcc, and ships it as an overlay (see [Toolchain Overlays](#toolchain-overlays)).

An arch opts in simply by having a rust overlay (`TC_OVERLAY_RUSTC`); the Synology-vendored triple (`…-unknown-…` → `…-synology-…`) is derived from the central arch map. The C toolchain keeps its stock vendor `gcc`+`ld`; only the Rust link routes through the binutils 2.30 overlay (`RUST_LINK_VIA_BINUTILS`). The rust builds made with the gcc 8.5 overlay are installed beside the vendor one, and not selected.

### Building Rust

```bash
make -C native/rustc-1.82 arch-ppc853x-5.2  # one arch
make -C native/rustc-1.82 all-5.2          # every rust arch of a DSM version
make -C native/rustc-1.98 all-6.2.4        # built with the gcc 8.5 overlay (OVERLAY_GCC)
```

You do **not** build binutils separately: the Rust build co-builds `native/binutils-2.30` for the same `(arch, DSM)` automatically (the `rustc_binutils_cobuild` step, gated on `RUST_LINK_VIA_BINUTILS`). It is intentionally not a `DEPENDS` -- a `DEPENDS` cannot carry the per-arch parametrization -- so `make arch-<arch>-<vers>` is self-contained. The build prints a `Co-building binutils …` banner when it does so. Publish the result as in [Building and publishing an overlay](#building-and-publishing-an-overlay).

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
