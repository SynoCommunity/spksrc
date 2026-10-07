# Makefile Variables

This page documents the Makefile variables used in spksrc packages.

!!! tip "Reference Documentation"
    For a complete reference of all variables and targets, see [Makefile Reference](../../reference/makefile-reference.md).

!!! warning "Include Order Matters"
    Architecture variables (`ARMv7_ARCHS`, `x64_ARCHS`, etc.) and the helper macros are defined by `spksrc.common.mk`, which loads the architecture classification and macros early (see [Macros](../../reference/macros.md)). Any `ifeq` using them must therefore appear **after** `include ../../mk/spksrc.common.mk` (or the relevant `spksrc.cross-*.mk`, which includes it) — referenced before the include they are empty.

## Package Identification

### Cross Packages

| Variable | Required | Description |
|----------|----------|-------------|
| `PKG_NAME` | Yes | Package name (lowercase, hyphens) |
| `PKG_VERS` | Yes | Package version |
| `PKG_EXT` | Yes | Source file extension (tar.gz, tar.xz, zip) |
| `PKG_DIST_NAME` | Yes | Source filename to download |
| `PKG_DIST_SITE` | Yes | Base URL for download |
| `PKG_DIST_MIRRORS` | No | Extra base URLs to fall back to (see [Source downloads and mirrors](#source-downloads-and-mirrors)) |
| `PKG_DIR` | Yes | Directory name after extraction |

Example:

```makefile
PKG_NAME = curl
PKG_VERS = 8.4.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://curl.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
```

### Source downloads and mirrors

**Where the source comes from.** `PKG_DOWNLOAD_METHOD` selects how
`PKG_DIST_SITE` is fetched; it defaults to a plain HTTP download, which is what
almost every package wants.

| `PKG_DOWNLOAD_METHOD` | Fetches | Revision variable |
|-----------------------|---------|-------------------|
| unset / anything else | the tarball at `PKG_DIST_SITE/PKG_DIST_NAME` | — |
| `git` | a clone, archived to a tarball | `PKG_GIT_HASH` |
| `svn` | an export, archived to a tarball | `PKG_SVN_REV` (or `HEAD`) |
| `hg` | a clone, archived to a tarball | `PKG_HG_REV` (or `tip`) |

The VCS methods build the tarball locally from one repository, so **everything
below applies to HTTP downloads only** — there is nothing to mirror when the
source is a revision in a named repository.

A download is never a single request. The framework builds a list of candidate
URLs, tries each in turn, and stops at the first success. The list is finite --
the primary URL, plus the mirrors described below, de-duplicated -- and each
candidate is retried `DOWNLOAD_TRIES` times (2 by default), so a download that
cannot succeed fails instead of looping.

**Well-known project mirrors are automatic.** If `PKG_DIST_SITE` points at one
of the big source hosts, the framework already knows its mirrors and will try
them without any declaration on your part:

| If the URL is hosted on | Fallbacks are taken from | Tree root |
|-------------------------|--------------------------|-----------|
| GNU (`ftp.gnu.org`, `ftpmirror.gnu.org`) | `MIRROR_GNU` | `/gnu/` |
| SourceForge (`downloads.sourceforge.net`) | `MIRROR_SOURCEFORGE` | `/project/` |
| GNOME (`download.gnome.org`) | `MIRROR_GNOME` | `/sources/` |
| kernel.org (`cdn.kernel.org`, `www.kernel.org`) | `MIRROR_KERNEL` | `/pub/` |
| Savannah (`download.savannah.gnu.org`) | `MIRROR_SAVANNAH` | `/releases/` |
| GnuPG (`gnupg.org`, `www.gnupg.org`) | `MIRROR_GNUPG` | `/gcrypt/` |
| freedesktop.org (any `*.freedesktop.org`) | `MIRROR_FREEDESKTOP` | *by file name* |

Most families are **path-preserving**: a candidate is built by replacing
everything up to and including the family's tree-root marker with the mirror
base, so a mirror hosting the tree under a different prefix still resolves.

freedesktop.org is the exception. Its mirrors are archives that flatten the
layout, so only the **file name** is appended to each base -- the same rule
`PKG_DIST_MIRRORS` follows. The bases embed `$(PKG_NAME)` for that reason:

```makefile
MIRROR_FREEDESKTOP ?= https://ftp.osuosl.org/pub/blfs/conglomeration/$(PKG_NAME) \
                      https://distfiles.macports.org/$(PKG_NAME)
```

Any other URL -- GitHub, a project's own server -- simply has no family, and the
primary URL is used on its own. Every base is overridable from `local.mk`, since
each is declared with `?=`.

**`PKG_DIST_MIRRORS` covers everything else.** It takes a space-separated list of
*base URLs*; `PKG_DIST_NAME` is appended to each. Use it when upstream is the
right place to fetch from but cannot be relied on:

```makefile
PKG_DIST_SITE = https://znc.in/releases
# znc.in serves the release tarballs, but it has been flaky (its TLS
# certificate expired on 2026-07-14). Fall back to our own mirror.
PKG_DIST_MIRRORS = https://github.com/SynoCommunity/spksrc/releases/download/sources
```

Two things to keep in mind:

- The **file name must match**. The mirror has to serve the file under exactly
  `PKG_DIST_NAME`. A distribution that repackages the tarball under its own name
  (Debian's `znc_1.10.2.orig.tar.gz`, say) cannot be used as a mirror base.
- The **digests still apply**. Every candidate is checked against `digests`, so a
  mirror serving different bytes fails the build rather than poisoning it. This
  is what makes it safe to list a third-party mirror at all.

When no mirror serves the right file name, the durable answer is to upload the
tarball to the SynoCommunity
[`sources`](https://github.com/SynoCommunity/spksrc/releases/tag/sources)
release and point `PKG_DIST_MIRRORS` at it.

### SPK Packages

| Variable | Required | Description |
|----------|----------|-------------|
| `SPK_NAME` | Yes | Package name shown in Package Center |
| `SPK_VERS` | Yes | Version displayed to users |
| `SPK_REV` | Yes | Revision number (increment for each release) |
| `SPK_ICON` | No | Path to package icon (256x256+ PNG, auto-resized) |

## Metadata

| Variable | Required | Description |
|----------|----------|-------------|
| `HOMEPAGE` | No | Project website |
| `COMMENT` | Yes | Short description |
| `LICENSE` | Yes | License name (GPLv2, MIT, etc.) |
| `LICENSE_FILE` | No | Path to license agreement file |
| `MAINTAINER` | Yes | Package maintainer name |
| `DESCRIPTION` | SPK only | Full description for Package Center |
| `DISPLAY_NAME` | SPK only | Display name in Package Center |
| `CHANGELOG` | SPK only | Changes in this version |

## Dependencies

### Build Dependencies

| Variable | Description |
|----------|-------------|
| `DEPENDS` | Cross packages to build/include |
| `BUILD_DEPENDS` | Packages needed only for building |
| `NATIVE_DEPENDS` | Native tools needed for building |
| `OPTIONAL_DEPENDS` | Dependencies some architectures pull and others do not |

```makefile
# Include these in the SPK
DEPENDS = cross/curl cross/openssl3

# Only needed during build
BUILD_DEPENDS = native/cmake
```

A feature that comes with its own dependency is best declared with
[`$(call depend,...)`](../../reference/macros.md#dependencies): the dependency is taken,
with its switch, wherever its own floors are met — no condition to copy from it.

```makefile
$(call depend,cross/vvenc,--enable-libvvenc)
```

### How DEPENDS and OPTIONAL_DEPENDS are processed

The two lists are read in different ways depending on what make is asked to do.

| Context | `DEPENDS` | `OPTIONAL_DEPENDS` |
|---------|-----------|--------------------|
| Build (`make arch-<arch>-<vers>`, `make ARCH=… TCVERSION=…`) | built, in list order | **not built** -- only what also reached `DEPENDS` is |
| Pre-check, before any build | its whole tree checked against the arch's capability gates; any refusal stops the build | ignored |
| `make check-<arch>-<vers>` | listed as **required** | walked too, listed as **optional**; never a refusal |
| No `ARCH` (`make dependency-list-spk`, `dependency-flat`, `dependency-tree`) | walked | **walked like `DEPENDS`** |

**Building.** `depend_target` (`spksrc.rules/dependency.mk`) runs `native/` dependencies
first, then every `cross/` entry of `BUILD_DEPENDS` and `DEPENDS`, one after the other, in
the order the list ends up with, each as a full make in its own directory staging into the
caller's `WORK_DIR`. A dependency reached by several paths is built once per run. Where one
package must be built before another (tvheadend's pngquant before zlib), the order of
`DEPENDS` is what guarantees it.

**Without an `ARCH`** every condition a Makefile tests is false or empty (`TC_GCC` is
unset), so `DEPENDS` alone would miss whatever an architecture adds. That is why
`OPTIONAL_DEPENDS` exists: it names everything **some** architecture may pull, and the
no-`ARCH` walks follow it. The CI pre-downloads sources from `make dependency-list-spk`,
which runs exactly there -- a dependency named only under a condition, and not in
`OPTIONAL_DEPENDS`, is never fetched into the distrib cache.

**Under an `ARCH`**, `OPTIONAL_DEPENDS` is a declaration, not a build list: an entry is
built only when it also reached `DEPENDS`. `WALK_OPTIONAL_DEPENDS=1` makes a walk follow it
anyway, for reporting -- the **optional** section of `make check` -- and changes nothing
about what gets built. `make check` also says which of the package's own optional
dependencies this arch ended up with (`optional in use` / `optional unused`).

**Capability gates.** The pre-check walks the required tree (`DEPENDS`, recursively) and
refuses the arch if any package in it fails a floor (`MIN_GCC_VERSION`,
`MIN_GLIBC_VERSION`, `MIN_KERNEL_VERSION`, `REQUIRE_64BIT`, `UNSUPPORTED_ARCHS`, …), naming
every one. An optional dependency's floor never refuses the package -- which is exactly why
a dependency the build can do without must not sit in `DEPENDS` unconditionally.

#### `$(call depend,...)`: resolved before the pre-check

[`$(call depend,...)`](../../reference/macros.md#dependencies) fills both lists for you.
Its optional form declares the packages in `OPTIONAL_DEPENDS` and registers them;
`spksrc.rules/depend.mk`, included by the entry points just **before** the pre-check, then
asks each candidate's own tree whether it supports `ARCH`-`TCVERSION` (the same verdict as
`make check`) and appends the supported ones to `DEPENDS`, with their switches. So:

- **Verdicts are computed once per work directory**, all candidates in parallel, and kept in
  `work-<arch>-<vers>/depend-<package>.mk`. After changing a dependency's floors,
  `make spkclean` (or `clean`) recomputes them.
- **The order is the order of the Makefile.** Each call leaves a placeholder in `DEPENDS`
  and `CONFIGURE_ARGS` where it stands, which the outcome replaces -- the package and its
  switches, the `<else>` switches, or nothing -- exactly as an `ifeq` at that line would.
- **Dependency walks** (pre-check, `make check`, `dependency-flat` under an arch) do not
  compute optional verdicts: they reuse the file a build wrote, or leave optional
  dependencies out -- the required tree stays the required tree. **Required alternatives**
  (`cross/a|cross/b` with no switch, a virtual package) are resolved in walks too, since the
  tree must hold the version that is picked.
- **With no `ARCH`** nothing is resolved; the `OPTIONAL_DEPENDS` declaration carries every
  candidate to `dependency-list-spk`.

#### Writing it

- **Include `spksrc.common.mk` before the first `$(call depend,...)`.** The macro is defined
  there; called earlier, it expands to nothing, silently. Virtual packages need it too.
- **Never reset `DEPENDS`, `CONFIGURE_ARGS` or `OPTIONAL_DEPENDS` with `=` after a call**:
  it wipes what the calls declared, placeholders included. Use `+=`, or put the `=` first.
- **Known limitation: do not test the content of `DEPENDS` or `CONFIGURE_ARGS` while
  parsing**, after a call (`ifneq ($(filter cross/x,$(DEPENDS)),)`): until `spksrc.rules/depend.mk` has
  run, they hold the placeholder, not the package. Where a Makefile must decide on that,
  use a classic `ifeq` on the condition itself.
- **A call inside an `ifeq` that a no-`ARCH` parse does not enter** (`VIDEODRV_ON`, an arch
  test) cannot declare its package: name it in `OPTIONAL_DEPENDS` yourself.
- **Keep `ifeq` for conditions that belong to the consumer**, not to the dependency: a
  videodriver option, a choice paired with the `spk/` (tvheadend's ffmpeg4 or ffmpeg8).
  A condition that merely repeats a dependency's floor goes away: declare the floor in the
  dependency and use `$(call depend,...)`.

### SPK Dependencies

| Variable | Description |
|----------|-------------|
| `SPK_DEPENDS` | Other SPK packages required at runtime |
| `SPK_CONFLICT` | Packages that conflict with this one |

```makefile
# Requires WebStation to be installed
SPK_DEPENDS = "WebStation>=3.0"

# Cannot be installed alongside
SPK_CONFLICT = "transmission"
```

## Build Configuration

These variables apply to `cross/` package Makefiles.

### Build System Selection

A cross package's build system is chosen by which `mk/spksrc.cross-*.mk` it includes; the arguments are then passed through the matching variable:

| Build system | Include | Arguments variable |
|--------------|---------|--------------------|
| autotools | `spksrc.cross-cc.mk` + `GNU_CONFIGURE = 1` | `CONFIGURE_ARGS` |
| CMake | `spksrc.cross-cmake.mk` | `CONFIGURE_ARGS` |
| Meson | `spksrc.cross-meson.mk` | `CONFIGURE_ARGS` (passed to `meson setup`) |

All three build systems also honour `ADDITIONAL_CONFIGURE_ARGS`, appended right
after `CONFIGURE_ARGS` on the configure/cmake/`meson setup` command line. It is
never set by the framework. Prefer `CONFIGURE_ARGS +=`; reach for
`ADDITIONAL_CONFIGURE_ARGS` only when a package reuses `CONFIGURE_ARGS` for its
own extra configure invocations and needs args that go to the framework's
invocation *only* (see `cross/x265`, whose 10/12-bit sub-builds share
`CONFIGURE_ARGS` but must not receive the final-build link flags).

```makefile
# autotools
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared --disable-static
CONFIGURE_ARGS += --with-ssl=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
```

```makefile
# Meson (CONFIGURE_ARGS is forwarded to `meson setup`)
CONFIGURE_ARGS = -Dtests=disabled

include ../../mk/spksrc.cross-meson.mk
```

### Compiler Flags

| Variable | Description |
|----------|-------------|
| `ADDITIONAL_CFLAGS` | Extra C compiler flags |
| `ADDITIONAL_CXXFLAGS` | Extra C++ compiler flags |
| `ADDITIONAL_CPPFLAGS` | Extra preprocessor flags |
| `ADDITIONAL_LDFLAGS` | Extra linker flags |

```makefile
ADDITIONAL_CFLAGS = -O3 -DNDEBUG
ADDITIONAL_LDFLAGS = -Wl,-rpath,/var/packages/mypackage/target/lib
```

These `ADDITIONAL_*` variables are **package**-scoped. The **toolchain**-wide
counterparts — the target ABI in `TC_EXTRA_BUILD_FLAGS` (folded into each
`TC_EXTRA_<LANG>FLAGS`) and the link flags in `TC_EXTRA_LDFLAGS` (`-lrt` /
`-latomic`) — are declared by the toolchain, not the package; see
[Extra flags a toolchain can declare](../../framework/toolchain.md#extra-flags-a-toolchain-can-declare).

### Compile and Install Arguments

`COMPILE_ARGS` and `INSTALL_ARGS` carry extra arguments for the compile and install steps across every build system. For autotools / plain GNU make each is the make command; for CMake and Meson they are appended as-is to `cmake --build` / `cmake --install` and `ninja` / `ninja install` respectively.

On the classic gnu-make build path only (not CMake or Meson) both variables have a sensible default when a package leaves them unset, so package-specific make routines can reference them directly:

- `COMPILE_ARGS` defaults to `-j$(NCPUS)` (parallel jobs).
- `INSTALL_ARGS` defaults to `install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)`.

| Variable | Description |
|----------|-------------|
| `COMPILE_ARGS` | Extra arguments for the compile step (make / cmake --build / ninja); defaults to `-j$(NCPUS)` on the make path |
| `INSTALL_ARGS` | Extra arguments for the install step (make / cmake --install / ninja install); defaults to `install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)` on the make path |
| `INSTALL_TARGET` | Make target for installation (default: install) |

```makefile
COMPILE_ARGS = V=1
INSTALL_ARGS = install-strip DESTDIR=$(INSTALL_DIR)
```

## Service Configuration

These variables apply to `spk/` package Makefiles.

| Variable | Description |
|----------|-------------|
| `STARTABLE` | `yes` if package has a service to start |
| `SERVICE_USER` | `auto` to create `sc-<packagename>` user (required for DSM 7) |
| `SERVICE_SETUP` | Path to service-setup.sh |
| `SERVICE_PORT` | Port used by the service |
| `SERVICE_PORT_TITLE` | Label for the port |
| `SERVICE_WIZARD_SHARENAME` | Wizard share variable for shared folder |
| `FWPORTS` | Path to firewall port configuration file |
| `SPK_COMMANDS` | List of `bin/command` paths for `/usr/local/bin` symlinks |

```makefile
STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8080
SERVICE_PORT_TITLE = Web Interface

# Firewall ports (creates resource entry)
FWPORTS = src/mypackage.sc

# Commands to link to /usr/local/bin
SPK_COMMANDS = bin/mycommand bin/myother
```

## Architecture Support

### Declare a capability floor (preferred)

When a package cannot build on some architectures because of what the
**toolchain** provides — its compiler, its C library, or the target being
32-bit — declare that floor instead of listing the architectures by hand. The
framework checks each floor against the toolchain's own `TC_GCC` / `TC_GLIBC` /
`TC_RUSTC` and refuses exactly the architectures that cannot meet it, with a
human-readable reason.

| Variable | Description |
|----------|-------------|
| `MIN_GCC_VERSION` | Needs at least this gcc (e.g. `8`, `4.9`) |
| `MIN_BINUTILS_VERSION` | Needs at least this binutils — the `as` and `ld` the toolchain ships |
| `MIN_GLIBC_VERSION` | Needs at least this glibc — a runtime floor no toolchain can lift |
| `MIN_KERNEL_VERSION` | Needs at least this kernel — a runtime floor no toolchain can lift |
| `MIN_RUSTC_VERSION` | Needs at least this rustc (e.g. `1.85`) |
| `REQUIRE_64BIT` | Set to `1` when the package needs a 64-bit target |

```makefile
# Needs C++17 → gcc 8 or newer
MIN_GCC_VERSION = 8

# Needs Rust edition 2024 → rustc 1.85 or newer
MIN_RUSTC_VERSION = 1.85

# Needs an ld that knows R_PPC_TLSGD → binutils 2.20 or newer
MIN_BINUTILS_VERSION = 2.20

# Needs a 64-bit target (e.g. SVT-AV1)
REQUIRE_64BIT = 1
```

Why this over an arch list: a hardcoded list says *where* a package fails, not
*why*. It has to be rechecked by hand every time a toolchain moves, and it
cannot express "any architecture whose gcc is older than X". A declared floor
can, and it stays correct on its own. Unmet floors accumulate, so an arch that
misses more than one is told about all of them.

The toolchain values these check against — `TC_GCC`, `TC_GLIBC` and `TC_KERNEL`
— are declared in each toolchain's Makefile and read statically, so a package
can gate on them before anything is extracted.

`TC_RUSTC` is the exception: it is *derived*, not declared. An arch whose Rust
overlay is active reports the version that overlay pins; every other arch reports
`stable`, which sorts above any number and therefore clears any `MIN_RUSTC_VERSION`
without a network query. So a rustc floor refuses only the archs pinned to an old
from-source Rust — see [Toolchain: custom from-source
Rust](../../framework/toolchain.md#custom-from-source-rust-toolchains).

**Ask what stands in the way.** `make check-<arch>-<tcvers>` lists every check the
package's whole dependency tree fails for that architecture, so a floor declared three
levels down is visible without starting a build:

```
$ make check-x86-5.2
===>  tvheadend: x86-5.2 check: 17 failed, 14 more behind an optional dependency
       required
         cross/ffmpeg8              gcc 4.7.3 < 4.9
         cross/python314            gcc 4.7.3 < 4.8
         ...
       optional
         cross/frei0r               gcc 4.7.3 < 7.5
         cross/openexr              gcc 4.7.3 < 4.8
         ...
```

`make ARCH=x86 TCVERSION=5.2 check` is the same with the pair in variables, and a clear
architecture answers `x86-5.2 check: OK`. **required** is what the build actually needs;
**optional** is what an `OPTIONAL_DEPENDS` branch would demand if that option were turned
on -- worth knowing before turning it on, and never a reason to refuse the build. A
package under both a required and an optional parent counts as required.

The pre-check runs the same walk on the required set, so a refused build names every
blocker at once instead of stopping at the first.

**Keep the floor consistent between `spk/` and `cross/`.** A floor on an `spk/`
package belongs on its matching `cross/` package too, so a build is refused at its
own level instead of failing deep in a dependency. If you add a floor to `spk/foo`,
add it to `cross/foo` as well.

**Let the essential dependencies set the floor.** Every mandatory dependency must
build at the floor the package declares; if one of them needs a newer gcc or glibc,
raise the floor on the package *and* its `cross/` to match. Do **not** push that
floor onto a shared `cross/` library, though — a library keeps the minimum *it*
needs, so other packages built against it at a lower floor stay buildable.

**Make an optional dependency optional instead of raising the floor.** When a
dependency is optional, do not lift the whole package's floor for it. Declare it with
`$(call depend,cross/x,--enable-x)`: it is taken, with its configure option, wherever its
own floors are met, and dropped elsewhere -- the way ffmpeg's codecs are wired. See
[How DEPENDS and OPTIONAL_DEPENDS are processed](#how-depends-and-optional_depends-are-processed).

### Exclude architectures explicitly

For an exclusion that is **not** a capability floor — a package that is simply
not wanted on a platform, or a specific arch/DSM-version pairing — use the arch
lists directly.

| Variable | Description |
|----------|-------------|
| `UNSUPPORTED_ARCHS` | Architectures that cannot build this package |
| `REQUIRED_MIN_DSM` | Minimum DSM version required |
| `OS_MIN_VER` | Minimum OS version (alternative to above) |

```makefile
# Not supported on this whole family
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

# Requires DSM 7.0+
REQUIRED_MIN_DSM = 7.0
```

### Architecture Groups

spksrc provides groups such as `x64_ARCHS`, `ARMv7_ARCHS`, `ARMv8_ARCHS`, `ARM_ARCHS`, `PPC_ARCHS`, `32bit_ARCHS` and `64bit_ARCHS`. The complete, authoritative list (with the platform codenames each contains) is in [Reference: Architectures](../../reference/architectures.md#architecture-groups).

Use them in `ifeq` to enable code per architecture. The groups are available **after** including a spksrc entry point (or `spksrc.common.mk`):

```makefile
include ../../mk/spksrc.common.mk

# Only build a feature on 64-bit targets
ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-feature
endif

# x64-only dependency
ifneq ($(findstring $(ARCH),$(x64_ARCHS)),)
DEPENDS += cross/intel-media-driver
endif

# Exclude a whole family from the build
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)
```

### Version Conditions

The `version_*` [macros](../../reference/macros.md#version-comparison) gate code on a toolchain (or any version) — they return `1` when true:

```makefile
include ../../mk/spksrc.common.mk

# Newer toolchains only
ifeq ($(call version_ge,$(TC_GCC),12),1)
DEPENDS += cross/libplacebo
endif

# Workaround for old compilers
ifeq ($(call version_lt,$(TC_GCC),5.0),1)
ADDITIONAL_CFLAGS += -std=gnu99
endif
```

## Path Variables (Available During Build)

| Variable | Description |
|----------|-------------|
| `WORK_DIR` | Package work directory |
| `PKG_DIR` | Extracted source directory |
| `INSTALL_DIR` | Installation destination |
| `STAGING_INSTALL_PREFIX` | Path prefix for installed files |
| `INSTALL_PREFIX` | Runtime prefix on NAS |

## SPK-Specific Variables

| Variable | Description |
|----------|-------------|
| `ADMIN_PORT` | Port for admin interface |
| `ADMIN_PROTOCOL` | Protocol (http/https) for admin interface |
| `ADMIN_URL` | Custom admin URL path |

```makefile
ADMIN_PORT = 8080
ADMIN_PROTOCOL = http
ADMIN_URL = /mypackage
```

## Web Interface Shortcuts

Packages with web interfaces can add a shortcut icon to the DSM main menu. For the complete list of variables, see the [Makefile Reference](../../reference/makefile-reference.md#web-interface-variables).

### Automatic Generation (Recommended)

Use `SERVICE_PORT` to automatically generate the shortcut:

```makefile
DSM_UI_DIR = app
SERVICE_PORT = 8096
SERVICE_PORT_TITLE = My App (HTTP)
ADMIN_PORT = $(SERVICE_PORT)
```

### Custom Configuration

For custom URL paths or descriptions, create `src/app/config`:

```json
{
    ".url": {
        "com.synocommunity.packages.<pkgname>": {
            "title": "Package Name",
            "desc": "Tooltip description",
            "icon": "images/<pkgname>-{0}.png",
            "type": "url",
            "protocol": "http",
            "port": "8080",
            "url": "/admin",
            "allUsers": true
        }
    }
}
```

Point `DSM_UI_CONFIG` at that file — the framework installs it as the package's `app/config`, overriding the auto-generated one:

```makefile
DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
ADMIN_PORT = 8080
ADMIN_URL = /admin
```
