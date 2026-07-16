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
│       ├── x86_64-pc-linux-gnu/    # Extracted toolchain
│       ├── tc_vars.mk              # Generated variables
│       ├── tc_vars.autotools.mk
│       ├── tc_vars.flags.mk
│       ├── tc_vars.cmake
│       └── tc_vars.meson-*
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

Each toolchain directory contains a Makefile describing *what* to fetch and *what
it targets*; the URL itself is derived by the framework (see
[Download Sources and Mirrors](#download-sources-and-mirrors)):

```makefile
TC_ARCH   = avoton
TC_VERS   = 6.2.4
TC_KERNEL = 3.10.105
TC_GLIBC  = 2.20

TC_DIST   = avoton-gcc493_glibc220_linaro_x86_64-GPL
TC_DIST_SITE_PATH = toolchains%2Fdsm6.2.4

TC_TARGET  = x86_64-pc-linux-gnu
TC_SYSROOT = $(TC_TARGET)/sys-root

include ../../mk/spksrc.toolchain.mk
```

| Variable | Meaning |
|----------|---------|
| `TC_ARCH` / `TC_VERS` | Platform codename and DSM version (match the directory name) |
| `TC_KERNEL` / `TC_GLIBC` | Kernel and glibc the toolchain targets — `TC_GLIBC` is the runtime floor |
| `TC_DIST` | Archive base name, without the `.txz` extension (`TC_DIST_NAME = $(TC_DIST).$(TC_EXT)`) |
| `TC_DIST_SITE_PATH` | Path under the host's download root (a release tag for spksrc-hosted files, a vendor folder name for Synology-hosted ones) |
| `TC_TARGET` | Target triple; also the extraction directory under `work/` |
| `TC_SYSROOT` | Sysroot location inside the extracted tree (layout varies: `sys-root`, `sysroot`, `libc`) |

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

Because these libraries are declared toolchain-wide, they reach every link even
though most binaries call neither `clock_gettime` nor an atomic builtin. The
framework therefore wraps them in `-Wl,--as-needed ... -Wl,--no-as-needed`, so the
linker records a `librt` / `libatomic` dependency only where the objects actually
reference a symbol it provides. The wrap is scoped to just these two libraries —
it restores the default immediately after — so it never drops a package library
that is present only for its side effects.

## Download Sources and Mirrors

A toolchain URL is assembled rather than hardcoded:

```
TC_DIST_SITE = https://<TC_WWW>/<url-map path>/<TC_DIST_SITE_PATH>
URLS         = $(TC_DIST_SITE)/$(TC_DIST_NAME)
```

- **`TC_VERSION_MAP`** (`mk/spksrc.toolchain/tc-versions.mk`) maps each OS version to
  `<build>:<type>:<source host>`. It is what decides whether a version is fetched
  from Synology or from spksrc:

  ```makefile
  6.2.4:25556:DSM:github.com/SynoCommunity/spksrc
  7.0:41890:DSM:global.synologydownload.com
  ```

- **`TC_URL_MAP`** (`mk/spksrc.toolchain/tc-url.mk`) maps each host to its download
  root, so only the host has to change to move a version between sources.

### spksrc mirror

Every toolchain also gets the matching spksrc release registered as a **fallback**
via `PKG_DIST_MIRRORS`:

```
https://github.com/SynoCommunity/spksrc/releases/download/toolchains%2F<type><version>
```

`download.mk` tries the original URL first, then appends the file name to each
mirror base in turn, so a build no longer breaks when the vendor removes or moves
a file. The candidate list is de-duplicated, so versions already served *from* the
spksrc release (6.2.4, 5.2, SRM) are unaffected. Nothing is needed per toolchain —
the mirror is derived from `TC_TYPE` and `TC_VERS`.

## Updating the Hosted Toolchains

spksrc keeps its own copy of the official toolchains so builds do not depend on
the vendor keeping files available (Synology has removed older toolchains before).
One GitHub release per OS version, tagged `toolchains/<type><version>`:

| Tag | Contents |
|-----|----------|
| `toolchains/dsm6.2.4` | DSM 6.2.4 official toolchains (also the primary source) |
| `toolchains/dsm7.0` | DSM 7.0 official toolchains (mirror) |
| `toolchains/srm1.3` | SRM 1.3 official toolchains |

To publish a new set:

1. **Create the tag and a (pre)release** named `toolchains/<type><version>`,
   matching the existing ones.
2. **Upload the official archives** under their original file names — the mirror
   URL appends `TC_DIST_NAME` verbatim, so the name must not be altered.
3. **Point the version at a source** in `TC_VERSION_MAP`: leave it on the vendor
   host to prefer the official source (the spksrc release then acts purely as a
   fallback), or switch it to `github.com/SynoCommunity/spksrc` to serve primarily
   from the release — as done for 6.2.4, whose vendor copies may disappear.
4. **Verify** a file resolves from both sources:
   ```bash
   cd toolchain/syno-avoton-6.2.4
   make -s --eval='u: ; @echo $(URLS)' u
   ```

## GCC Overlays

A toolchain's glibc is a hard runtime floor, but its **compiler** is not: older
DSM toolchains ship a gcc (4.9.3 on 6.2.4, 7.5.0 on 7.0) too old for modern C++.
An *overlay* rebuilds a newer gcc as a cross-compiler against the toolchain's
existing sysroot and extracts it next to the stock gcc, leaving glibc untouched.

- `native/gcc8` builds gcc 8.5 (the DSM 7.1/7.2 compiler) per toolchain and
  packages it with `make build-archive`.
- `toolchain/syno-<arch>-<vers>-gcc8` is the consumer: it downloads that archive
  and extracts it into the base toolchain's `work/` tree.
- `tc_vars` then selects the **newest** gcc it finds (`TC_GCC_SUFFIX` in
  `mk/spksrc.toolchain/tc_vars.mk`).

### Forcing the original toolchain

Set **`LEGACY_TOOLCHAIN = 1`** to ignore any overlay and build against the stock
Synology compiler. It is honoured by `tc_vars` and forwarded to it by the cross,
spk and kernel rules, so it works from the command line:

```bash
make LEGACY_TOOLCHAIN=1 -C spk/tvheadend arch-x64-6.2.4
```

or persistently, via the commented entry in the `local.mk` generated by
`make setup`:

```makefile
#LEGACY_TOOLCHAIN = 1
```

Use it to reproduce a legacy build, or when a package misbehaves with the newer
compiler.

## tc_vars Files

The toolchain build generates several `tc_vars*.mk` files that configure cross-compilation:

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

2. **Register the version** in `TC_VERSION_MAP` (`mk/spksrc.toolchain/tc-versions.mk`)
   as `<version>:<build>:<type>:<source host>` — the build number is part of the
   vendor download path:
   ```makefile
   8.0:<build>:DSM:global.synologydownload.com
   ```

3. **Create the Makefile** (the URL is derived, see [Toolchain Makefile](#toolchain-makefile)):
   ```makefile
   TC_ARCH   = x64
   TC_VERS   = 8.0
   TC_KERNEL = <kernel version>
   TC_GLIBC  = <glibc version>

   TC_DIST   = x64-gcc<ver>_glibc<ver>_x86_64-GPL
   TC_DIST_SITE_PATH = Intel%20x86%20Linux%20...%20%28x86_64%29

   TC_TARGET  = x86_64-pc-linux-gnu
   TC_SYSROOT = $(TC_TARGET)/sys-root

   include ../../mk/spksrc.toolchain.mk
   ```

4. **Generate the digests**:
   ```bash
   make -C toolchain/syno-x64-8.0 digests
   ```

5. **Test build**:
   ```bash
   make -C spk/transmission ARCH=x64 TCVERSION=8.0
   ```

6. **Mirror it** on an spksrc release, so the build survives the vendor removing
   the file — see [Updating the Hosted Toolchains](#updating-the-hosted-toolchains).

## Toolchain Build Process

The toolchain build follows this process:

1. **Download** - Fetches toolchain archive from Synology
2. **Checksum** - Verifies archive integrity
3. **Extract** - Unpacks to `work/` directory
4. **Normalize** - Applies patches for compatibility
5. **Rust** - Installs Rust toolchain components if needed
6. **tcvars** - Generates tc_vars*.mk files

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

## Troubleshooting

### Toolchain Download Fails

Print the URL the framework actually builds, and check it:

```bash
cd toolchain/syno-x64-7.2
make -s --eval='u: ; @echo $(URLS)' u
```

A vendor URL that has disappeared is expected to fall back to the
[spksrc mirror](#spksrc-mirror) automatically. If *all* candidates fail the
download stops with `All mirrors failed`; the archive may simply not be mirrored
yet — see [Updating the Hosted Toolchains](#updating-the-hosted-toolchains).

### tc_vars Not Generated

Remove the tcvars cookie and rebuild:
```bash
rm toolchain/syno-x64-7.2/work/.tcvars_done
make -C toolchain/syno-x64-7.2 tcvars
```

### Cross-Compiler Not Found

Ensure the toolchain is fully extracted:
```bash
ls toolchain/syno-x64-7.2/work/x86_64-pc-linux-gnu/bin/
```

## Related Documentation

- [Architecture](architecture.md) - Build pipeline overview
- [Makefile System](makefile-system.md) - mk/*.mk file details
- [Reference: Architectures](../reference/architectures.md) - Complete architecture reference
