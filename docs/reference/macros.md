---
title: Macros
description: GNU Make helper macros provided by spksrc and how to use them
---

# Macros

spksrc ships a small set of GNU Make helper macros in `mk/spksrc.common/macros.mk`. They are **loaded automatically**: `spksrc.common.mk` includes `spksrc.common/macros.mk` first, so the macros are available in any package Makefile that includes a spksrc entry point (`spksrc.cross-cc.mk`, `spksrc.spk.mk`, ...).

!!! note "Architecture awareness is loaded early too"
    The same `spksrc.common.mk` also pulls in the parse-time toolchain pre-bootstrap (`spksrc.common/stage0.mk`) and the architecture classification (`spksrc.common/archs.mk`). That is what makes `TC_GCC` and the [architecture groups](architectures.md#architecture-groups) available **while a package's `DEPENDS` are parsed**, so version- and arch-gated dependencies resolve correctly on a cold tree.

## Version comparison

These compare two version strings (natural/`sort -V` order) and return `1` when the test is true, empty otherwise — ideal for `ifeq`:

| Macro | True when |
|-------|-----------|
| `$(call version_le,A,B)` | A ≤ B |
| `$(call version_ge,A,B)` | A ≥ B |
| `$(call version_lt,A,B)` | A < B |
| `$(call version_gt,A,B)` | A > B |

```makefile
# Pull a dependency only on a recent enough toolchain
ifeq ($(call version_ge,$(TC_GCC),8.5),1)
DEPENDS += python/numpy-latest
endif

# Apply a workaround on older compilers
ifeq ($(call version_lt,$(TC_GCC),5.0),1)
ADDITIONAL_CFLAGS += -std=gnu99
endif
```

## Dependencies

`$(call depend,...)` declares a dependency the build takes **where it can**, with the
configure switches that come with it. It does not replace `DEPENDS` and
`OPTIONAL_DEPENDS`: it removes the conditions a package like ffmpeg had to copy, word for
word, from each of its dependencies.

The first argument is a list of packages, read two ways:

- **AND** -- packages separated by spaces, `cross/a cross/b ... cross/z`: the call holds
  when **every** one of them supports the build.
- **OR** -- alternatives separated by `|`, `cross/a|cross/b|...|cross/z`: the call holds
  with the **first** one that supports the build.

The two combine: `cross/a|cross/b cross/c` is "a or b, and c".

| Call | Effect |
|------|--------|
| `$(call depend,cross/x)` | `DEPENDS += cross/x` -- required, as before |
| `$(call depend,cross/a cross/b ... cross/z)` | required, all of them -- a plain `DEPENDS` too |
| `$(call depend,cross/a\|cross/b\|...\|cross/z)` | required alternatives: the first whose tree supports the build, else the last, which then refuses it -- a virtual package |
| `$(call depend,<list>,<if-switches>)` | optional: where the list holds, its packages go to `DEPENDS` and `<if-switches>` to `CONFIGURE_ARGS`; elsewhere nothing |
| `$(call depend,<list>,<if-switches>,<else-switches>)` | the same, and `<else-switches>` where the list does not hold |
| `$(call depend,<list>,nop)` | optional, with no switch |

`<list>` is any of the AND/OR forms above: one package, `cross/a cross/b ... cross/z`
(all must pass, else `<else-switches>`), `cross/a|cross/b|...|cross/z` (the first that
passes, else `<else-switches>`).

```makefile
include ../../mk/spksrc.common.mk

# required: a plain DEPENDS
$(call depend,cross/cairo)

# one package, if-switches: taken where vvenc's own floors (gcc 7.5, its archs) are met
$(call depend,cross/vvenc,--enable-libvvenc)

# one package, if- and else-switches: enabled by default upstream, so turned off by name
# where x265 cannot be built
$(call depend,cross/x265,--enable-libx265,--disable-libx265)

# no switch: the build finds it on its own
$(call depend,cross/intel-mediasdk,nop)

# AND: flac and libtheora together, or neither
$(call depend,cross/flac cross/libtheora,--enable-libtheora)

# AND with an else: dvbcsa needs both libraries
$(call depend,cross/libdvbcsa cross/dvb-apps,--enable-dvbcsa,--disable-dvbcsa)

# OR: the first supported version
$(call depend,cross/libvmaf_2.3|cross/libvmaf_1.5,--enable-libvmaf)

# OR with an else
$(call depend,cross/libvmaf_2.3|cross/libvmaf_1.5,--enable-libvmaf,--disable-libvmaf)

include ../../mk/spksrc.cross-cc.mk
```

!!! warning "Include `spksrc.common.mk` before the first call"
    The macro is defined there; called earlier it expands to nothing, silently.

### A virtual package

The required OR form, with no switch, is a whole virtual package: one of the versions is
required, the first one the architecture supports.

```makefile
PKG_NAME = libaom-virtual

include ../../mk/spksrc.common.mk

$(call depend,cross/libaom-latest|cross/libaom-3.8)

include ../../mk/spksrc.cross-virtual.mk
```

`make ARCH=x64 TCVERSION=6.2.4 check` -- the first version needs gcc 7.5, the second is
picked:

```
===>  libaom-virtual: x64-6.2.4 check: 0 failed, 1 more behind an optional dependency
       optional
         cross/libaom-latest        gcc 4.9.3 < 7.5
       optional in use : cross/libaom-3.8
       optional unused : cross/libaom-latest
```

`make check-x64-7.1` -- the first version is supported:

```
===>  libaom-virtual: x64-7.1 check: OK
       optional in use : cross/libaom-latest
       optional unused : cross/libaom-3.8
```

`make check-x86-5.2` -- neither is: the last one is kept, and refuses the build by name:

```
===>  libaom-virtual: x86-5.2 check: 1 failed, 1 more behind an optional dependency
       required
         cross/libaom-3.8           gcc 4.7.3 < 4.8
       optional
         cross/libaom-latest        gcc 4.7.3 < 7.5
       optional in use : cross/libaom-3.8
       optional unused : cross/libaom-latest
```

How the framework processes both lists, in a build, a walk and without an `ARCH`:
[How DEPENDS and OPTIONAL_DEPENDS are processed](../developer-guide/packaging/makefile-variables.md#how-depends-and-optional_depends-are-processed).

!!! note "The outcome keeps the place of the call"
    `DEPENDS` and `CONFIGURE_ARGS` come out in the order the Makefile lists them, as with
    an `ifeq` at that line. Until resolution, though, they hold a placeholder: do not test
    their content while parsing.

Instead of

```makefile
OPTIONAL_DEPENDS += cross/vvenc
...
ifeq ($(call version_ge,$(TC_GCC),7.5),1)
DEPENDS += cross/vvenc
CONFIGURE_ARGS += --enable-libvvenc
endif
```

where the `ifeq` repeats `MIN_GCC_VERSION = 7.5` from `cross/vvenc/Makefile`, and must be
kept in step with it by hand.

### How it decides

The verdict is the one [`make check`](../developer-guide/packaging/makefile-variables.md#architecture-support)
gives: the dependency and its required tree pass every gate (`MIN_GCC_VERSION`,
`MIN_GLIBC_VERSION`, `MIN_KERNEL_VERSION`, `REQUIRE_64BIT`, `UNSUPPORTED_ARCHS`, …) of
the build's `ARCH`-`TCVERSION`. So the condition **belongs to the dependency**: a floor
missing there is a floor to add there, not a condition to put back in the caller.

- Computed once per `WORK_DIR`, the candidates in parallel, and kept in
  `work-<arch>-<vers>/odepend-<package>.mk`. After changing a dependency's floors,
  `make clean` (or `spkclean`) to recompute.
- The optional dependency is always declared in `OPTIONAL_DEPENDS`, so
  `make dependency-list-spk` (no `ARCH`) still fetches its sources.
- A dependency walk (the pre-check, `make check`) computes verdicts only for required
  alternatives: it walks the required tree, and an unsupported optional dependency never
  refuses the build.
- `make check` reports the outcome: `optional in use` / `optional unused`.

!!! warning "A call inside an `ifeq` is not seen without an ARCH"
    A `$(call depend,...)` inside a block that a parse without `ARCH` does not enter (the
    videodriver block of ffmpeg, say) cannot declare its package: name it in
    `OPTIONAL_DEPENDS` yourself.

The switches go to `CONFIGURE_ARGS`, the one variable autotools, CMake and Meson builds all
read.

## Toolchain tools

`$(call tc,<tool>)` is the absolute path of a cross tool. Use it instead of assembling
`$(TC_PATH)$(TC_PREFIX)<tool>` by hand: an overlay toolchain lives somewhere else entirely
(`<consumer>/work/install/usr/local/bin`, against the base toolchain's
`<work>/<target>/bin`) and its gcc family carries a version suffix there, so a
hand-built path silently resolves to the **vendor** tool the moment an overlay is active.

| Tool family | Resolved through | Tools |
|-------------|------------------|-------|
| gcc | `TC_OVERLAY_GCC_PATH`, else `TC_PATH` (plus `TC_GCC_SUFFIX`) | `gcc` `g++` `c++` `cpp` `gfortran` |
| binutils | `TC_OVERLAY_BINUTILS_PATH`, else `TC_PATH` | `ld` `as` `ar` `nm` `ranlib` `strip` `objdump` `objcopy` `readelf` |
| anything else | `TC_PATH` | — |

`TC_OVERLAY_<c>_PATH` is empty unless that overlay is *active* for the build (see
[Overlay switches](../framework/toolchain.md#overlay-switches)), so the call is already
correct with no overlay and stays correct when one is grafted on — nothing to revisit in
the package.

```makefile
# ffmpeg takes its tools from the command line, not from CC/AR in the environment
CONFIGURE_ARGS += --cc=$(call tc,gcc)
CONFIGURE_ARGS += --ar=$(call tc,ar)

# a plain make line that would otherwise ignore the environment
COMPILE_ARGS = CC=$(call tc,gcc) AR=$(call tc,ar)
```

!!! tip "Most packages need nothing"
    Autotools, CMake and Meson builds already receive `CC`, `CXX`, `AR`… through the
    environment, overlay-aware. Reach for `$(call tc,...)` only where a build system
    ignores that and takes a tool path of its own.

### Host tools

`$(call native,<tool>)` is the same idea for the **build host** — the other half of the
`cross/` against `native/` split — and is what `native/` packages get in their environment:

```makefile
$(call tc,gcc)      # …/syno-x64-7.2/…/x86_64-pc-linux-gnu-gcc
$(call native,gcc)  # /usr/bin/gcc
```

It falls back to the bare name when the tool is absent, so a missing one fails by its own
name rather than as an empty command, and it uses `command -v` rather than `which`: the
former is a POSIX shell builtin, the latter an external binary a minimal image may not ship.

## List helpers

| Macro | Purpose |
|-------|---------|
| `$(call uniq,<list>)` | Remove duplicate words, preserving order |
| `$(call dedup,<string>,<delimiter>)` | De-duplicate a delimiter-separated string, preserving order |
| `$(call dedup-files,<files>)` | Remove duplicate files (compared by `md5sum`), preserving order |

```makefile
BUILD_DEPENDS := $(call uniq,spk/$(FFMPEG_PACKAGE) $(BUILD_DEPENDS))

SPK_DEPENDS := $(call dedup,$(PYTHON_PACKAGE):$(SPK_DEPENDS),:)
```

## See also

- [Developer Guide: Makefile Variables](../developer-guide/packaging/makefile-variables.md) — where these macros are commonly used
- [Reference: Architectures](architectures.md) — the architecture groups available for `ifeq` conditions
