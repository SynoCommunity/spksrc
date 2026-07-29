---
title: Toolkit
description: The Synology DSM development toolkit, made available on demand
---

# Toolkit

A *toolkit* is the matching Synology **DSM development toolkit** — a sysroot of DSM libraries and headers for a given platform/DSM version. It complements the [Toolchain](toolchain.md) (which provides the cross-compiler) for the rare packages that need to link against DSM-provided libraries.

## Not part of the normal build flow

Unlike the toolchain, the toolkit is **not** used by a normal build. It is only **made available on demand**: a package opts in with

```makefile
REQUIRE_TOOLKIT = 1
```

When set, the framework downloads/extracts the toolkit and generates its `tk_vars*` files (mirroring the toolchain's `tc_vars*`); otherwise `spksrc.toolkit.mk` is never pulled in.

## Structure

`spksrc.toolkit.mk` is the entry point; its implementation under `mk/spksrc.toolkit/` mirrors the toolchain and is detailed in the [Makefile System include hierarchy](makefile-system.md#include-hierarchy).

## Related Documentation

- [Toolchain](toolchain.md) — the cross-compiler side
- [Makefile System](makefile-system.md) — `mk/` structure and include hierarchy
