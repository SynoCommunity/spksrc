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
| `spksrc.cross-env.mk` | Cross-compilation environment setup |
| `spksrc.toolchain.mk` | Toolchain build and tc_vars generation |
| `spksrc.toolkit.mk` | Toolkit management |
| `spksrc.toolkit-flags.mk` | Toolkit-specific compiler flags |

### Build System Adapters

| File | Purpose |
|------|--------|
| `spksrc.cross-cmake.mk` | CMake cross-compilation |
| `spksrc.cross-cmake-env.mk` | CMake environment setup |
| `spksrc.cross-cmake-toolchainfile.mk` | CMake toolchain file generation |
| `spksrc.cross-meson.mk` | Meson cross-compilation |
| `spksrc.cross-meson-env.mk` | Meson environment setup |
| `spksrc.cross-meson-crossfile.mk` | Meson cross file generation |
| `spksrc.cross-go.mk` | Go cross-compilation |
| `spksrc.cross-go-env.mk` | Go environment setup |
| `spksrc.cross-rust.mk` | Rust cross-compilation |
| `spksrc.cross-rust-env.mk` | Rust environment setup |
| `spksrc.cross-dotnet.mk` | .NET cross-compilation |
| `spksrc.cross-dotnet-env.mk` | .NET environment setup |

### Native Builds

| File | Purpose |
|------|--------|
| `spksrc.native-cc.mk` | Native compilation entry point |
| `spksrc.native-env.mk` | Native build environment |
| `spksrc.native-cmake.mk` | Native CMake builds |
| `spksrc.native-meson.mk` | Native Meson builds |
| `spksrc.native-install.mk` | Native installation |

### Python/Wheel System

| File | Purpose |
|------|--------|
| `spksrc.python.mk` | Python package main include |
| `spksrc.python-module.mk` | Python module building |
| `spksrc.wheel.mk` | Wheel package orchestration |
| `spksrc.wheel-download.mk` | Wheel downloading |
| `spksrc.wheel-compile.mk` | Wheel compilation |
| `spksrc.wheel-install.mk` | Wheel installation |
| `spksrc.wheel-env.mk` | Wheel environment setup |
| `spksrc.crossenv.mk` | Cross-compilation virtual environment |

### SPK Package Creation

| File | Purpose |
|------|--------|
| `spksrc.spk.mk` | Main SPK package assembly |
| `spksrc.copy.mk` | Dependency copying to staging |
| `spksrc.strip.mk` | Binary stripping |
| `spksrc.icon.mk` | Icon processing |
| `spksrc.service.mk` | Service configuration generation |
| `spksrc.install-resources.mk` | Resource file installation |

### Service Scripts (Templates)

| File | Purpose |
|------|--------|
| `spksrc.service.installer.dsm6` | DSM 6 installer template |
| `spksrc.service.installer.dsm7` | DSM 7 installer template |
| `spksrc.service.installer.functions` | Common installer functions |
| `spksrc.service.start-stop-status` | Service control template |
| `spksrc.service.create_links` | Symlink creation helper |

## Include Hierarchy

Understanding the include hierarchy is critical for framework development:

```
spksrc.common.mk
└── spksrc.common/
    ├── archs.mk      # Architecture classification
    ├── logs.mk       # Logging helpers
    └── macros.mk     # GNU Make utility macros

spksrc.cross-cc.mk (cross/ packages)
├── spksrc.directories.mk
├── spksrc.common.mk
├── spksrc.pre-check.mk
├── spksrc.cross-env.mk
│   └── tc_vars*.mk (generated)
├── spksrc.download.mk
├── spksrc.depend.mk
├── spksrc.checksum.mk
├── spksrc.extract.mk
├── spksrc.patch.mk
├── spksrc.configure.mk
├── spksrc.compile.mk
├── spksrc.install.mk
└── spksrc.plist.mk

spksrc.spk.mk (spk/ packages)
├── spksrc.common.mk
├── spksrc.directories.mk
├── spksrc.pre-check.mk
├── spksrc.cross-env.mk
├── spksrc.depend.mk
├── spksrc.wheel.mk
├── spksrc.copy.mk
├── spksrc.strip.mk
└── spksrc.service.mk
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

### spksrc.cross-env.mk

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
# spksrc.cross-meson-env.mk - Environment setup
MESON_CROSS_FILE = $(WORK_DIR)/tc_vars.meson-cross
ENV += MESON_CROSS_FILE=$(MESON_CROSS_FILE)

# spksrc.cross-meson.mk - Build logic
include ../../mk/spksrc.cross-meson-env.mk
include ../../mk/spksrc.cross-meson-crossfile.mk

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
- [Toolchains](toolchains.md) - Toolchain management
- [Developer Guide: Build Rules](../developer-guide/packaging/build-rules.md) - Using build system includes
