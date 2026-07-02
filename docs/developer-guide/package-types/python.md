# Python Packages

This guide covers how to build Python-based SPK packages in spksrc, how their
dependencies are distributed as **wheels**, and how to handle the harder wheels
that live in the dedicated `python/` tree.

## Overview

A Python SPK bundles a Python interpreter (a `python3xx` package) plus the
third-party modules the application needs. Those modules are distributed as
**wheels** built by the framework:

- **Pure-python** wheels contain no compiled code and work on any architecture.
  By default they are *not* shipped inside the SPK — they are downloaded with
  `pip` at installation time.
- **Compiled** wheels (C / Rust / meson extensions) are cross-compiled at build
  time and bundled into the SPK's `share/wheelhouse`.

Most packages describe their wheels with plain `requirements-*.txt` files. The
few wheels that the default `pip` build cannot handle (they need meson, patches,
or other cross packages) live as standalone packages under `python/` and are
pulled in with `DEPENDS += python/<module>`.

## Wheel types

Each wheel type is described by a conventional requirements filename:

| Type | Requirements file | Description |
|------|-------------------|-------------|
| Pure Python | `requirements-pure.txt` | Platform-independent, no compilation |
| Crossenv | `requirements-crossenv.txt` | Cross-compiled C extensions |
| ABI3 limited | `requirements-abi3.txt` | Cross-compiled with the limited API/ABI (`cp3x` / `abi3`) |
| Exception (cross) | `requirements-cross.txt` | **Auto-generated** — one line per `python/<module>` dependency |

**Pure Python** packages are self-contained and architecture-independent.

**Crossenv** packages have C extensions that must be compiled with the
cross-toolchain against a cross-compiled Python, using a *crossenv* environment.

**ABI3 limited** packages are crossenv packages that additionally enforce the
limited API (`--py-limited-api`), producing a single wheel usable across Python
3.x releases. Set `PYTHON_LIMITED_API` (default `cp37`) to pick the floor.

**Exception wheels** are the hard cases the default `pip` build does not handle
well — a wheel that must be built with **meson**, one that depends on other
cross packages at build time, or one that needs patches. These live under
`python/` (see [The `python/` tree](#the-python-tree-exception-wheels)); you
never edit `requirements-cross.txt` by hand — the framework writes each
`python/<module>` into it automatically.

A requirement filename that is none of the recognized names is treated as
**crossenv** when building for an architecture (and **pure** when no `ARCH` is
set). Force the type of a whole file with `WHEEL_DEFAULT_PREFIX=pure`, or of a
single line with a per-line prefix (see
[Crossenv requirement files](#crossenv-requirement-files)).

## How spksrc processes wheels

For every wheel that must be bundled, the framework:

1. Reads the requirement files listed in `WHEELS`.
2. Cross-compiles each wheel into `$(WORK_DIR)/wheelhouse`.
3. Renames wheels to match the target DSM machine name (required for ARM
   architectures such as `armv5tel` and `armv7l`).
4. Copies them to `$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/wheelhouse`.
5. Writes a consolidated `requirements.txt` covering every bundled wheel, used
   by the runtime virtualenv.

Pure-python wheels are downloaded at install time instead of being bundled,
unless `WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1` is set.

## Creating a Python SPK

### Makefile setup

```makefile
SPK_NAME = myapp
SPK_VERS = 1.0.0
SPK_REV = 1

# Bundle a Python interpreter (must be set BEFORE spksrc.spk-meta.mk)
PYTHON_PACKAGE = python314

# Requirement files to build/bundle (activates wheel processing)
WHEELS  = src/requirements-pure.txt
WHEELS += src/requirements-crossenv.txt

include ../../mk/spksrc.spk-meta.mk
```

Setting `PYTHON_PACKAGE` and including `spksrc.spk-meta.mk` bundles the chosen
Python and pulls in the wheel routines (`spk-meta.mk` includes `spksrc.spk.mk`);
the `python314` dependency is added automatically. `PYTHON_PACKAGE` **must** be
set before the `include`.

### Advanced wheel options

| Variable | Purpose |
|----------|---------|
| `WHEELS_BUILD_ARGS` | Extra options passed to the wheel build (e.g. pip `-C key=value` config settings) |
| `WHEELS_CFLAGS` / `WHEELS_CPPFLAGS` / `WHEELS_CXXFLAGS` / `WHEELS_LDFLAGS` | Extra compiler/linker flags for C/C++ wheels |
| `PYTHON_LIMITED_API` | Limited API tag for `requirements-abi3.txt` wheels (default `cp37`) |
| `WHEEL_DEFAULT_PREFIX` | Type used for an unrecognized requirement filename (`crossenv` with `ARCH`, otherwise `pure`) |
| `WHEELS_PURE_PYTHON_PACKAGING_ENABLE` | Bundle pure-python wheels into the SPK instead of downloading them at install time |

At the SPK level several wheels are built from the same variable, so the flag
variables above accept a **per-wheel** `[name] flags` syntax — only the bracket
whose name matches the wheel being built is applied:

```makefile
# Applies only to the llfuse and msgpack wheels
WHEELS_CFLAGS  = [llfuse] -std=gnu99 -DCYTHON_ATOMICS=0
WHEELS_CFLAGS += [msgpack] -std=gnu99
```

### Service setup

Point the service at the bundled Python and let the helper build the runtime
virtualenv from the wheelhouse:

```bash
PYTHON_DIR="/var/packages/python314/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${PATH}"

service_postinst() {
    # Framework helper: creates the virtualenv and installs the bundled wheels
    install_python_virtualenv
}
```

### PLIST entry

Ship the wheelhouse:

```
rsc:share/wheelhouse
```

## Building and rebuilding wheels

### Prerequisite

The cross-compiled Python is built as part of the normal package build. To build
it explicitly first:

```bash
make -C spk/python314 ARCH=x64 TCVERSION=7.2
make -C spk/myapp     ARCH=x64 TCVERSION=7.2
```

### Selecting what to (re)build with `WHEELS`

`WHEELS` controls which wheels the wheel targets act on:

| Invocation | Effect |
|------------|--------|
| *unset* (use the Makefile's `WHEELS`) | build every wheel the package declares |
| `WHEELS=""` (explicitly empty) | build nothing — the wheel step is skipped |
| `WHEELS="pkg1==ver pkg2==ver ..."` | build only those wheels, on demand |

The package's default wheels are built as part of the ordinary
`make arch-<arch>-<tcvers>` / `make all` build. The explicit
`make wheel-<arch>-<tcvers>` target **requires** a non-empty `WHEELS` and errors
with *No python wheel to process* otherwise.

```bash
# Build a single wheel on demand (overrides the Makefile's WHEELS)
make WHEELS="cryptography==41.0.0" wheel-x64-7.2

# Download the wheel sources only, without building
make download-wheels
```

### Crossenv

The crossenv is created automatically during the build, at
`work-<arch>-<version>/crossenv-default`. For manual control:

```bash
# Build the default crossenv
make crossenv-x64-7.2

# Build a crossenv for a specific wheel: selects the matching
# requirements-<name>[-<version>].txt below (see next section)
make WHEEL_NAME=lxml WHEEL_VERSION=5.2.2 crossenv-x64-7.2
```

> **Note:** there is no `WHEEL=` variable. A named crossenv is selected with the
> `WHEEL_NAME` / `WHEEL_VERSION` pair — this is what the framework passes
> internally when building a `python/<module>` wheel.

### Cleanup

Targets in increasing scope:

```bash
make wheelclean         # built wheels + wheel status cookies
make wheelcleancache    # also drop the local pip cache (work-*/pip)
make wheelcleanall      # also drop the shared download cache (distrib/pip)
make crossenvclean      # wheelclean + the crossenv dirs and their cookies
make crossenvcleanall   # wheelcleanall + crossenvclean (everything)
```

### Crossenv requirement files

Each Python meta carries the crossenv definitions used to compile wheels, under
`spk/<python_package>/crossenv/` (e.g. `spk/python314/crossenv/`). When building
a wheel, the framework selects the **most specific** matching file:

1. `requirements-<wheel>-<version>.txt` — one exact version (e.g. `requirements-numpy-1.26.4.txt`)
2. `requirements-<wheel>.txt` — any version of that wheel
3. `requirements-default.txt` — everything else

Within a file, each line targets a part of the crossenv via a prefix:

| Prefix | Installed into | Purpose |
|--------|----------------|---------|
| *(none)* | **both** the build and cross Python | bootstrap packages — the pinned `pip` / `setuptools` / `wheel` |
| `build:` | the **build** (host) Python | tools that compile the wheel (Cython, meson, hatchling, maturin, setuptools-scm, ...) |
| `cross:` | the **cross** (target) Python | build-time deps the wheel needs in the target environment (cffi, pybind11, ...) |
| `wheelhouse:` | the **cross** Python, from the local wheelhouse | install an already-compiled wheel — typically one **not on PyPI** (e.g. a `numpy` built earlier in the same run) |

`pure:`, `abi3:` and `crossenv:` may also prefix a line to force that wheel's
build type.

## The `python/` tree (exception wheels)

When a wheel is poorly handled by the default `pip` build — it needs meson,
patches, or other cross packages — it is built as a dedicated package under
`python/` (kept separate from `cross/` so the hard cases are easy to spot). Each
such package produces exactly one wheel and registers itself into the consuming
SPK's `requirements-cross.txt` automatically.

### A `python/<module>` Makefile

```makefile
PKG_NAME = mywheel
PKG_VERS = 1.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/m/mywheel
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Build-time cross dependencies of the C extension
DEPENDS = cross/libfoo

HOMEPAGE = https://example.com/mywheel
COMMENT = My Python wheel with C extensions
LICENSE = MIT

include ../../mk/spksrc.common.mk

# For a meson-built wheel, include spksrc.python-wheel-meson.mk instead
include ../../mk/spksrc.python-wheel.mk
```

`WHEELS_BUILD_ARGS` and the `WHEELS_*FLAGS` variables apply here too; because a
`python/` package builds a single wheel, the `[name]` prefix is optional.

**When several versions must coexist**, set `PKG_REAL_NAME` to the real module
name and encode the version in `PKG_NAME` — the directory name then
disambiguates the variants:

```makefile
PKG_NAME = numpy_$(PKG_VERS)   # directory python/numpy_1.26
PKG_REAL_NAME = numpy          # the actual wheel/module name
```

### Referencing it from an SPK

```makefile
# Automatically added to requirements-cross.txt in the wheelhouse
DEPENDS += python/mywheel
```

### Real examples

- **`python/pillow`** — a setuptools wheel with several cross dependencies
  (`cross/freetype`, `cross/libjpeg`, ...) whose optional features are toggled
  through `WHEELS_BUILD_ARGS` (`-C jpeg=enable`, ...).
- **`python/numpy`** — a meson wheel (`spksrc.python-wheel-meson.mk`) that
  generates a `--cross-file`, depends on `cross/openblas`, and uses
  `PKG_REAL_NAME` so `numpy`, `numpy_1.26` and `numpy-latest` can coexist.

## Best practices

### Pin exact versions

```
# Good — reproducible
requests==2.31.0
urllib3==2.0.4

# Bad — breaks build reproducibility
requests>=2.0
urllib3
```

### Include all dependencies

Do not rely on pip resolving dependencies at install time. Generate the full
set in a local virtualenv:

```bash
pip install -r requirements.txt
pip freeze > requirements-complete.txt
```

Then remove the build tools (`setuptools`, `pip`, `wheel`) and anything already
handled as a `DEPENDS` / cross / `python/` package.

### Identify wheel types from the filename

Check the wheel filenames on [PyPI](https://pypi.org/):

| Filename pattern | Type |
|------------------|------|
| `*-py3-none-any.whl` / `*-py2.py3-none-any.whl` | Pure Python |
| `*-cp314-cp314-manylinux*.whl` | Needs cross-compilation (crossenv) |
| `*-cp314-abi3-*.whl` | ABI3 limited |

### Troubleshooting

| Symptom | Likely fix |
|---------|-----------|
| `command 'gcc' failed` | The package needs cross-compilation — move it out of `requirements-pure.txt` |
| Wheel builds but fails at install | Cross-compile it instead of treating it as pure |
| Missing dependencies at runtime | `pip freeze` to capture the complete dependency set |
| C extension needs a special flag | Add it via `WHEELS_CFLAGS`/`WHEELS_CPPFLAGS` (with a `[name]` prefix at the SPK level) |
| Source archive ships no generated C code (e.g. gevent) | Download the sdist from PyPI rather than a GitHub tag |

## Examples

- [borgbackup](https://github.com/SynoCommunity/spksrc/tree/master/spk/borgbackup) — SPK with pure + crossenv requirement files, per-wheel `WHEELS_CFLAGS`, and `WHEELS_PURE_PYTHON_PACKAGING_ENABLE`
- [python314-wheels](https://github.com/SynoCommunity/spksrc/tree/master/spk/python314-wheels) — wheel testing package exercising many wheel types and `python/` dependencies

## See also

- [Wheel format documentation](https://wheel.readthedocs.io/)
- [PyPI](https://pypi.org/) — Python Package Index
- [Makefile Reference](../../reference/makefile-reference.md) — `WHEELS`, `PYTHON_PACKAGE` and related variables
