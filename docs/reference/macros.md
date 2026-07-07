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
