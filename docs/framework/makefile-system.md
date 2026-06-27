# Makefile System

This document provides a deep dive into the `mk/*.mk` files that form the core of the spksrc build system.

## File Organization

The `mk/` directory contains all makefile includes, organized by function:

### Core Files

| File | Purpose |
|------|--------|
| `spksrc.common.mk` | Base settings, utilities, parallel build config |
| `spksrc.common/directories.mk` | Work directory paths |

### Rules

| File | Purpose |
|------|--------|
| `spksrc.rules.mk` | Rules entry point (`clean`, `smart-clean`, `changelog`, `rustup`); aggregates `dependency-tree.mk` + `generate-digests.mk` |
| `spksrc.rules/depend.mk` | Dependency resolution and build |
| `spksrc.rules/dependency-tree.mk` | Dependency graph |
| `spksrc.rules/generate-digests.mk` | Digests generation |
| `spksrc.rules/pre-check.mk` | Pre-build validation |
| `spksrc.rules/status.mk` | Build status tracking |
| `spksrc.rules/supported.mk` | Arch/version support (`build-arch-*` targets) |
| `spksrc.rules/tests.mk` | Test harness rules |

### Build Pipeline

| File | Purpose |
|------|--------|
| `spksrc.build.mk` | Standard build pipeline aggregator (download → install); included by `spksrc.cross-cc.mk` and `spksrc.native-cc.mk` |
| `spksrc.build/download.mk` | Source download from URLs/Git |
| `spksrc.build/checksum.mk` | Archive integrity verification |
| `spksrc.build/extract.mk` | Archive extraction |
| `spksrc.build/patch.mk` | Patch application |
| `spksrc.build/configure.mk` | Configure stage orchestration |
| `spksrc.build/compile.mk` | Compilation orchestration |
| `spksrc.build/install.mk` | Installation to staging |
| `spksrc.build/plist.mk` | Package list generation |

### Cross-Compilation

| File | Purpose |
|------|--------|
| `spksrc.cross-cc.mk` | Main cross-compilation entry point |
| `spksrc.cross/env-default.mk` | Cross-compilation environment setup |
| `spksrc.toolchain.mk` | Toolchain build and tc_vars generation |
| `spksrc.toolkit.mk` | Toolkit management |

### Build System Adapters

| File | Purpose |
|------|--------|
| `spksrc.cross-cmake.mk` | CMake cross-compilation |
| `spksrc.cross/env-cmake.mk` | CMake environment setup |
| `spksrc.cross/cmake-toolchainfile.mk` | CMake toolchain file generation |
| `spksrc.cross-meson.mk` | Meson cross-compilation |
| `spksrc.cross/env-meson.mk` | Meson environment setup |
| `spksrc.cross/meson-crossfile.mk` | Meson cross file generation |
| `spksrc.cross-go.mk` | Go cross-compilation |
| `spksrc.cross/env-go.mk` | Go environment setup |
| `spksrc.cross-rust.mk` | Rust cross-compilation |
| `spksrc.cross/env-rust.mk` | Rust environment setup |
| `spksrc.cross-dotnet.mk` | .NET cross-compilation |
| `spksrc.cross/env-dotnet.mk` | .NET environment setup |

### Native Builds

| File | Purpose |
|------|--------|
| `spksrc.native-cc.mk` | Native compilation entry point |
| `spksrc.native/env-default.mk` | Native build environment |
| `spksrc.native-cmake.mk` | Native CMake builds |
| `spksrc.native-meson.mk` | Native Meson builds |
| `spksrc.native-install.mk` | Native installation |

### Python/Wheel System

| File | Purpose |
|------|--------|
| `spksrc.python-wheel.mk` | Main include for an exception wheel under `python/` (pip/crossenv) |
| `spksrc.python-wheel-meson.mk` | Same, for meson-built wheels |
| `spksrc.wheel.mk` | Wheel package orchestration (via `spksrc.spk.mk`) |
| `spksrc.wheel/download.mk` | Wheel downloading |
| `spksrc.wheel/compile.mk` | Wheel compilation |
| `spksrc.wheel/install.mk` | Wheel installation |
| `spksrc.wheel/env.mk` | Wheel environment setup |
| `spksrc.python-crossenv.mk` | Cross-compilation virtual environment |

### SPK Package Creation

| File | Purpose |
|------|--------|
| `spksrc.spk.mk` | Main SPK package assembly |
| `spksrc.spk-meta.mk` | Meta-consumer entry point: sets up the ffmpeg/python/videodriver meta(s), then includes `spksrc.spk.mk` |
| `spksrc.spk-meta/base.mk` | `SPK_BASE_TEMPLATE` — wires a meta's staging into the consumer |
| `spksrc.spk-meta/meta.mk` | Generates `tc_vars.meta.mk`, an inspectable diagnostic of the meta env (never `-include`d) |
| `spksrc.spk/copy.mk` | Dependency copying to staging |
| `spksrc.spk/strip.mk` | Binary stripping |
| `spksrc.spk/icon.mk` | Icon processing |
| `spksrc.service.mk` | Service configuration generation |
| `spksrc.install-resources.mk` | Resource file installation |

### Service Scripts (Templates)

| File | Purpose |
|------|--------|
| `spksrc.service/installer.dsm6` | DSM 6 installer template |
| `spksrc.service/installer.dsm7` | DSM 7 installer template |
| `spksrc.service/installer.functions` | Common installer functions |
| `spksrc.service/start-stop-status` | Service control template |
| `spksrc.service/create_links` | Symlink creation helper |

## Include Hierarchy

The framework is organized as **entry-point `.mk` files at the `mk/` root** plus, for each subsystem, a `spksrc.<name>/` directory of helper files. `spksrc.common.mk` is auto-loaded by every entry point (see [Macros](../reference/macros.md)):

```
# Foundation — auto-loaded by every entry point (see Macros); entry points
# also pull in the shared Core files and the build pipeline below.
spksrc.common.mk
spksrc.common/
├── archs.mk                  # architecture classification / groups
├── directories.mk            # work/staging/distrib directory layout
├── logs.mk                   # logging helpers
├── macros.mk                 # GNU Make helper macros
└── stage0.mk                 # parse-time toolchain pre-bootstrap (TC_GCC)

# Build pipeline — the per-package steps
spksrc.build.mk               # standard pipeline aggregator (download -> install),
                              # included by spksrc.cross-cc.mk and spksrc.native-cc.mk
spksrc.build/
├── download.mk               # source download
├── checksum.mk               # archive verification
├── extract.mk                # archive extraction
├── patch.mk                  # patch application
├── configure.mk              # configure
├── compile.mk                # compile
├── install.mk                # install to staging
├── plist.mk                  # package list generation (cross/kernel/main-depends; not in build.mk)
└── ninja.mk                  # ninja helper (cmake/meson)

# Rules — shared targets / orchestration, included by the entry points
spksrc.rules.mk               # rules entry point: clean/changelog targets,
                              # aggregates dependency-tree.mk + generate-digests.mk
spksrc.rules/
├── depend.mk                 # dependency resolution/build
├── dependency-tree.mk        # dependency graph
├── generate-digests.mk       # digests generation
├── pre-check.mk              # pre-build validation
├── status.mk                 # build status tracking
├── supported.mk              # arch/version support (build-arch-* targets)
└── tests.mk                  # test harness rules

# Cross-compilation entry points (a cross/ package includes one)
spksrc.cross-cc.mk            # autotools / plain C/C++
spksrc.cross-cmake.mk         # CMake
spksrc.cross-dotnet.mk        # .NET
spksrc.cross-go.mk            # Go
spksrc.cross-meson.mk         # Meson
spksrc.cross-rust.mk          # Rust
spksrc.cross/                 # environment setup loaded by the entry points above
├── cmake-toolchainfile.mk    # generated CMake toolchain file
├── env-cmake.mk
├── env-default.mk            # base cross env
├── env-dotnet.mk
├── env-go.mk
├── env-meson.mk
├── env-rust.mk
└── meson-crossfile.mk        # generated Meson cross file

# Native build entry points
spksrc.native-cc.mk
spksrc.native-cmake.mk
spksrc.native-install.mk
spksrc.native-meson.mk
spksrc.native/
├── env-cmake.mk
├── env-default.mk            # base native env
└── env-meson.mk

# SPK assembly entry point
spksrc.spk.mk
spksrc.spk/
├── copy.mk                   # dependency copying to staging
├── icon.mk                   # icon processing
├── publish.mk                # publish to package server
└── strip.mk                  # binary stripping

# Meta-consumer entry point (sets up the meta(s), then includes spksrc.spk.mk)
spksrc.spk-meta.mk
spksrc.spk-meta/
├── base.mk                   # SPK_BASE_TEMPLATE
├── ffmpeg.mk                 # when FFMPEG_PACKAGE is set
├── meta.mk                   # generates tc_vars.meta.mk
├── python.mk                 # when PYTHON_PACKAGE is set
└── videodriver.mk            # when VIDEODRV_PACKAGE is set

# Service configuration entry point
spksrc.service.mk
spksrc.service/
├── create_links
├── installer.dsm5
├── installer.dsm6
├── installer.dsm7
├── installer.functions
├── non-startable
├── privilege-installasroot
├── start-stop-status
├── testcase
├── use_alternate_tmpdir
└── use_alternate_tmpdir.dsm7

# Python wheel entry point
spksrc.wheel.mk
spksrc.wheel/
├── compile.mk
├── download.mk
├── env.mk
├── install.mk
└── requirement.mk

# Toolchain entry point
spksrc.toolchain.mk
spksrc.toolchain/
├── tc-base.mk
├── tc-flags.mk
├── tc-normalize.mk
├── tc-rust.mk
├── tc-url.mk
├── tc-versions.mk
└── tc_vars.mk                # generates the tc_vars* files

# Toolkit entry point (only via REQUIRE_TOOLKIT)
spksrc.toolkit.mk
spksrc.toolkit/
├── tk-base.mk
├── tk-flags.mk
├── tk-normalize.mk
├── tk-url.mk
├── tk-versions.mk
└── tk_vars.mk                # generates the tk_vars* files
```

## Key Implementation Details

### spksrc.common.mk

The foundation of all builds. Key responsibilities:

- **BASEDIR detection** - Determines repository root
- **Local config loading** - Includes `local.mk` if present
- **Parallel build setup** - Configures `PARALLEL_MAKE` and `NCPUS`
- **Common utilities** - `MSG`, `RUN`, language definitions

```makefile
# Key variables defined
BASEDIR        # Repository root
MSG            # Message output helper
RUN            # Command execution in package environment
LANGUAGES      # Supported localization languages
PARALLEL_MAKE  # Parallel build mode
NCPUS          # CPU count for parallel builds
```

### spksrc.cross-cc.mk

The main entry point for cross-compiled packages. Implements the two-stage build:

```makefile
# Stage 1: Toolchain
cross-stage1: $(TCVARS_DONE)
    @$(MAKE) -C toolchain/$(TC) toolchain
    @$(MAKE) -C toolchain/$(TC) tcvars

# Stage 2: Package build
cross-stage2:
    # Standard pipeline: depend → configure → compile → install → plist
```

### spksrc.cross/env-default.mk

Sets up the cross-compilation environment by loading tc_vars files:

```makefile
# Loads toolchain configuration
include $(WORK_DIR)/tc_vars.mk
include $(WORK_DIR)/tc_vars.$(DEFAULT_ENV).mk

# Exports to ENV for command execution
ENV += CC=$(TC_CC) CXX=$(TC_CXX) ...
```

### spksrc.spk.mk

Orchestrates final SPK package creation:

1. **INFO generation** - Package metadata
2. **Script generation** - Install/upgrade scripts from templates
3. **Wizard processing** - Mustache template rendering
4. **Package assembly** - Creates package.tgz and SPK archive

### spksrc.service.mk

Generates service-related files and configuration:

- Processes `FWPORTS` into resource files
- Generates `SPK_COMMANDS` for usr-local-linker
- Creates service control scripts
- Handles DSM version-specific differences

## Adding New Build System Support

To add support for a new build system:

1. **Create environment file**: `spksrc.cross-<system>-env.mk`
   - Define environment variables needed
   - Handle toolchain file generation if needed

2. **Create main include**: `spksrc.cross-<system>.mk`
   - Include the environment file
   - Define configure/compile targets

3. **Update spksrc.build/configure.mk**:
   - Add detection for the new build system
   - Include the new makefile when detected

### Example: Meson Support

```makefile
# spksrc.cross/env-meson.mk - Environment setup
MESON_CROSS_FILE = $(WORK_DIR)/tc_vars.meson-cross
ENV += MESON_CROSS_FILE=$(MESON_CROSS_FILE)

# spksrc.cross-meson.mk - Build logic
include ../../mk/spksrc.cross/env-meson.mk
include ../../mk/spksrc.cross/meson-crossfile.mk

configure_target:
    meson setup --cross-file $(MESON_CROSS_FILE) ...
```

## Cookie System Details

Cookies track build progress and enable incremental builds:

```makefile
# Cookie file naming
COOKIE_PREFIX = $(PKG_NAME)-
COOKIE_FILE = $(WORK_DIR)/.$(COOKIE_PREFIX)<stage>_done

# Stage completion
download_target:
    # ... download logic ...
    @touch $(WORK_DIR)/.$(COOKIE_PREFIX)download_done
```

To force a rebuild from a specific stage, remove the corresponding cookie:

```bash
rm work-x64-7.2/.mypackage-configure_done
```

## Debugging Framework Issues

### Print Variable Values

```makefile
# Add to package Makefile temporarily
debug:
    @echo "CC=$(CC)"
    @echo "STAGING_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX)"
    @echo "ENV=$(ENV)"
```

### Verbose Make

```bash
# Show all commands
make -C spk/mypackage ARCH=x64 TCVERSION=7.2 V=1

# Show makefile parsing
make -C spk/mypackage ARCH=x64 TCVERSION=7.2 --debug=v
```

### Check Include Order

```bash
make -C spk/mypackage ARCH=x64 TCVERSION=7.2 --debug=m 2>&1 | grep 'Reading makefile'
```

## Related Documentation

- [Architecture](architecture.md) - Build pipeline overview
- [Toolchains](toolchain.md) - Toolchain management
- [Developer Guide: Build Rules](../developer-guide/packaging/build-rules.md) - Using build system includes
