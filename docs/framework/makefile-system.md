# Makefile System

This document provides a deep dive into the `mk/*.mk` files that form the core of the spksrc build system.

## File Organization

The `mk/` directory contains all makefile includes, organized by function:

### Core Files

| File | Purpose |
|------|--------|
| `spksrc.common.mk` | Base settings, utilities, parallel build config |
| `spksrc.directories.mk` | Work directory paths |
| `spksrc.pre-check.mk` | Pre-build validation |
| `spksrc.status.mk` | Build status tracking |

### Build Pipeline

| File | Purpose |
|------|--------|
| `spksrc.download.mk` | Source download from URLs/Git |
| `spksrc.checksum.mk` | Archive integrity verification |
| `spksrc.extract.mk` | Archive extraction |
| `spksrc.patch.mk` | Patch application |
| `spksrc.configure.mk` | Configure stage orchestration |
| `spksrc.compile.mk` | Compilation orchestration |
| `spksrc.install.mk` | Installation to staging |
| `spksrc.plist.mk` | Package list generation |

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
| `spksrc.crossenv.mk` | Cross-compilation virtual environment |

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

Understanding the include hierarchy is critical for framework development. `spksrc.common.mk` (and the files under `spksrc.common/`) is auto-loaded by every entry point — see [Macros](../reference/macros.md) for what it brings in and why:

```
spksrc.common.mk                 # auto-loaded by every entry point — see Macros for details
├── spksrc.common/
│   ├── macros.mk                # GNU Make helper macros (loaded first)
│   ├── stage0.mk                # parse-time toolchain pre-bootstrap (TC_GCC)
│   ├── archs.mk                 # architecture classification / groups
│   └── logs.mk                  # logging helpers
└── spksrc.directories.mk        # work/staging/distrib directory layout

spksrc.cross-cc.mk (cross/ packages)
├── spksrc.directories.mk
├── spksrc.common.mk
├── spksrc.pre-check.mk
├── spksrc.cross/env-default.mk
│   └── tc_vars*.mk (generated)
├── spksrc.download.mk
├── spksrc.depend.mk
├── spksrc.status.mk
├── spksrc.checksum.mk
├── spksrc.extract.mk
├── spksrc.patch.mk
├── spksrc.configure.mk
├── spksrc.compile.mk
├── spksrc.install.mk
├── spksrc.plist.mk
└── spksrc.supported.mk

spksrc.spk.mk (spk/ packages — the standard SPK entry point)
├── spksrc.directories.mk
├── spksrc.common.mk
├── spksrc.pre-check.mk
├── spksrc.cross/env-default.mk
├── spksrc.depend.mk
├── spksrc.wheel.mk
├── spksrc.spk/copy.mk
├── spksrc.spk/strip.mk
├── spksrc.service.mk
├── spksrc.spk/icon.mk
├── spksrc.supported.mk
└── spksrc.spk/publish.mk

spksrc.spk-meta.mk (meta-consumer spk/ packages: FFMPEG/PYTHON/VIDEODRV_PACKAGE)
│   # a thin wrapper that sets up the meta(s), then includes spksrc.spk.mk above
└── spksrc.spk-meta/
    ├── base.mk                 # SPK_BASE_TEMPLATE
    ├── videodriver.mk          # included when VIDEODRV_PACKAGE is set
    ├── python.mk               # included when PYTHON_PACKAGE is set
    ├── ffmpeg.mk               # included when FFMPEG_PACKAGE is set
    └── meta.mk                 # generates tc_vars.meta.mk (pulled in by base.mk)

spksrc.wheel.mk (wheel orchestration — included by spksrc.spk.mk)
└── spksrc.wheel/
    ├── env.mk                  # wheel build environment
    ├── requirement.mk          # requirement-file processing
    ├── download.mk             # wheel source download
    ├── compile.mk              # wheel compilation
    └── install.mk              # wheel installation

spksrc.service.mk (service config — included by spksrc.spk.mk)
└── spksrc.service/
    ├── installer.dsm5/6/7      # per-DSM installer templates
    ├── installer.functions     # shared installer helpers
    ├── start-stop-status       # service control template
    ├── create_links            # symlink creation helper
    ├── privilege-installasroot # privilege template
    ├── non-startable           # non-service package template
    └── use_alternate_tmpdir(.dsm7)

spksrc.toolchain.mk (toolchain/ entry point)
└── spksrc.toolchain/
    ├── tc-base.mk              # build / extract
    ├── tc-url.mk               # download URLs
    ├── tc-versions.mk          # version / identity resolution
    ├── tc-normalize.mk         # path / triplet normalization
    ├── tc-flags.mk             # compiler / linker flag derivation
    ├── tc-rust.mk              # rust toolchain setup
    └── tc_vars.mk              # generates the tc_vars* files

spksrc.toolkit.mk (toolkit/ entry point — only via REQUIRE_TOOLKIT, not the normal flow)
└── spksrc.toolkit/
    ├── tk-base.mk
    ├── tk-url.mk
    ├── tk-versions.mk
    ├── tk-normalize.mk
    ├── tk-flags.mk
    └── tk_vars.mk              # generates the tk_vars* files

spksrc.cross-{cmake,meson,go,rust,dotnet}.mk (build-system entry points)
└── spksrc.cross/
    ├── env-default.mk          # base cross env (also used by spksrc.cross-cc.mk)
    ├── env-cmake.mk            # CMake environment
    ├── cmake-toolchainfile.mk  # generated CMake toolchain file
    ├── env-meson.mk            # Meson environment
    ├── meson-crossfile.mk      # generated Meson cross file
    ├── env-go.mk               # Go environment
    ├── env-rust.mk             # Rust environment
    └── env-dotnet.mk           # .NET environment

spksrc.native-{cc,cmake,meson}.mk (native build entry points)
└── spksrc.native/
    ├── env-default.mk          # base native env
    ├── env-cmake.mk            # native CMake environment
    └── env-meson.mk            # native Meson environment
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

3. **Update spksrc.configure.mk**:
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
