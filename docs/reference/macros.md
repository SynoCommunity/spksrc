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
