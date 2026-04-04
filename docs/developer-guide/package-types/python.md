# Python Packages

This guide covers how to create Python-based SPK packages in spksrc using wheel distribution.

## Overview

Python packages in spksrc use wheels to distribute dependencies alongside your SPK.

## Wheel Types

Generally speaking, there are four types of Python packages:

| Type | Requirements File | Description |
|------|-------------------|-------------|
| Pure Python | `requirements-pure.txt` | Platform-independent |
| Crossenv | `requirements-crossenv.txt` | Cross-compiled packages with C extensions |
| ABI3 Limited | `requirements-abi3.txt` | Limited API/ABI compatibility |
| Cross packages | `requirements-cross.txt` | Auto-generated from `cross/` packages |

### Wheel Type Details

**Pure Python packages** are platform-independent and self-contained. They don't require compilation and work on any architecture.

**Crossenv packages** have C extensions that must be compiled with GCC. They require a cross-compiled Python and a crossenv environment.

**ABI3 Limited packages** enforce limited API/ABI compatibility to Python 3.x (`cp3x`) and ABI to Python 3 (`abi3`). Otherwise similar to crossenv packages.

**Cross packages** are packages that either:

- Have C extensions depending on other cross-packages at build time
- Need patches applied to create a working wheel

These require creating a new `cross/` package in spksrc.

## How spksrc Handles Wheels

By default, spksrc does **not** include pure-python wheels in the SPK. Instead, they're downloaded at installation time using `pip`.

For other wheel types, spksrc:

1. Stores requirement files in `$(WORK_DIR)/wheelhouse`
2. Compiles each wheel type and stores originals in `$(WORK_DIR)/wheelhouse`
3. Renames wheels to match the target DSM machine name (required for ARM architectures like `armv5tel` and `armv7l`)
4. Copies wheels to `$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/wheelhouse`
5. Creates a consolidated `requirements.txt` including all wheel types

Any other requirement filename will be treated as crossenv type by default. This can be changed by setting `WHEEL_DEFAULT_PREFIX=pure`.

## Creating a Python Package

### Makefile Setup

```makefile
SPK_NAME = myapp
SPK_VERS = 1.0.0
SPK_REV = 1

PYTHON_PACKAGE = python312
SPK_DEPENDS = "python312"

# Wheel requirements
WHEELS = src/requirements-pure.txt
WHEELS += src/requirements-crossenv.txt

include ../../mk/spksrc.python.mk
```

### Service Setup

Configure the service to use the correct Python version:

```bash
PYTHON_DIR="/var/packages/python312/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}:${PATH}"

service_postinst() {
    # Framework helper creates virtualenv and installs wheels
    install_python_virtualenv
}
```

### PLIST Entry

Add the wheelhouse to your PLIST:

```
rsc:share/wheelhouse
```

## Build Prerequisites

Before building wheels with crossenv, ensure the Python dependency is built first:

```bash
# Build Python dependency first
make -C spk/python312 ARCH=x64 TCVERSION=7.2

# Then build your package
make -C spk/myapp ARCH=x64 TCVERSION=7.2
```

## Crossenv Commands

### Creating and Managing Crossenv

Crossenv is automatically created during the build process at `spk/<package>/work-<arch>-<version>/crossenv-default`. For manual control:

```bash
# Create default crossenv
make crossenv-x64-7.2

# Create crossenv for specific wheel (debugging)
WHEEL="lxml-5.2.2" make crossenv-x64-7.2

# Clean crossenv
make crossenvclean
```

### Debugging Wheel Builds

```bash
# Debug specific wheel version
WHEEL="cryptography==41.0.0" make crossenv-x64-7.2

# List installed wheels in crossenv
ls spk/myapp/work-x64-7.2/crossenv-default/cross/lib/python3.12/site-packages/
```

## Creating Cross Packages for Wheels

When a Python package needs patches or depends on other cross packages, create a `cross/` package:

### Cross Package Makefile

```makefile
PKG_NAME = mywheel
PKG_VERS = 1.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/m/mywheel
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/python312

HOMEPAGE = https://example.com/mywheel
COMMENT = My Python wheel with C extensions
LICENSE = MIT

include ../../mk/spksrc.python-wheel.mk
```

### SPK Makefile with Cross Package

```makefile
BUILD_DEPENDS = cross/python312 cross/mywheel

# The wheel is auto-added to requirements-cross.txt
```

## Example: Mercurial Package

This example shows a package with both pure-python and cross-compiled dependencies.

**Mercurial** needs cross-compiling (has C extensions) and patches. **Docutils** is pure-python.

### Pure Python Dependency (Docutils)

In `spk/mercurial/src/requirements.txt`:

```
docutils==0.17.1
```

### Cross Package (Mercurial)

1. Create `cross/mercurial/Makefile` with `include ../../mk/spksrc.python-wheel.mk`
2. Add patches to `cross/mercurial/patches/`
3. Create digests file

### SPK Makefile

```makefile
BUILD_DEPENDS = cross/python312 cross/mercurial
WHEELS = src/requirements.txt
```

### Installing Wheels at Runtime

In your `service-setup.sh`, the `install_python_virtualenv` helper handles this. For manual control:

```bash
# Create virtualenv
${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env

# Install wheels
${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall \
    -f ${SYNOPKG_PKGDEST}/share/wheelhouse \
    ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl
```

## Best Practices

### Version Pinning

**Always pin exact versions** in requirements files:

```
# Good
requests==2.31.0
urllib3==2.0.4

# Bad - will cause build reproducibility issues
requests>=2.0
urllib3
```

### Include All Dependencies

Don't rely on pip to resolve dependencies at install time. To get the complete list:

```bash
# In a local virtualenv
pip install -r requirements.txt
pip freeze > requirements-complete.txt
```

Use the output as your starting point.

### Exclude Build Tools

Remove or comment out these from requirements files:

- `setuptools`
- `pip`
- `wheel`

Also exclude any packages handled as `DEPENDS` or cross packages.

### Identifying Wheel Types

Check wheel filenames on [PyPI](https://pypi.org/) to determine type:

| Filename Pattern | Type |
|------------------|------|
| `*-py3-none-any.whl` | Pure Python |
| `*-py2.py3-none-any.whl` | Pure Python |
| `*-cp312-cp312-manylinux*.whl` | Needs cross-compilation |
| `*-cp312-abi3-*.whl` | ABI3 limited |

### Troubleshooting

| Error | Solution |
|-------|----------|
| `command 'gcc' failed` | Package needs cross-compilation |
| Wheel builds but fails at install | Try cross-compiling instead of pure |
| Missing dependencies at runtime | Run `pip freeze` to get complete deps |

### Build Notes

- Some wheels need `ADDITIONAL_CFLAGS = -Wno-error=format-security`
- Some source archives (like gevent) don't include generated C code - download from PyPI instead of GitHub

## Examples

- [borgbackup](https://github.com/SynoCommunity/spksrc/tree/master/spk/borgbackup) - Comprehensive Python package with cross-compiled dependencies
- [python312-wheels](https://github.com/SynoCommunity/spksrc/tree/master/spk/python312-wheels) - Wheel testing package
- [homeassistant](https://github.com/SynoCommunity/spksrc/tree/master/spk/homeassistant) - Large Python application with many dependencies

## See Also

- [Wheel Format Documentation](https://wheel.readthedocs.io/)
- [PyPI](https://pypi.org/) - Python Package Index
- [Makefile Reference](../../reference/makefile-reference.md) - WHEELS and PYTHON_PACKAGE variables
