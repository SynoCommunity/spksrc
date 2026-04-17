# Build Architecture

This document describes the internal architecture of the spksrc build system, including the build pipeline, stage interactions, and how packages are assembled.

## Build Pipeline Overview

The spksrc build system uses a pipeline-based architecture where each build stage depends on the previous one. The pipeline is implemented through GNU Make with cookie files tracking completion.

```mermaid
block
  columns 7
  download space checksum space extract space patch
  space space space space space space space
  plist space install space compile space configure

  download --> checksum
  checksum --> extract
  extract --> patch
  patch --> configure
  configure --> compile
  compile --> install
  install --> plist
```

## Cross-Compilation Stages

Cross-compilation in spksrc is divided into two distinct stages:

### Stage 1: Toolchain Bootstrap

Stage 1 ensures the cross-compilation toolchain is ready:

1. **Toolchain Download** - Fetches the Synology toolchain for the target architecture
2. **Toolchain Extraction** - Unpacks the toolchain to the working directory
3. **tc_vars Generation** - Creates environment files that configure the build:
   - `tc_vars.mk` - Core toolchain identity and paths
   - `tc_vars.autotools.mk` - Autotools adapter variables
   - `tc_vars.flags.mk` - C/C++ compiler flags
   - `tc_vars.rust.mk` - Rust environment (if applicable)
   - `tc_vars.cmake` - CMake toolchain file
   - `tc_vars.meson-*` - Meson cross/native configuration files

Stage 1 is idempotent—if the `.tcvars_done` cookie exists, it's skipped.

### Stage 2: Package Build

Stage 2 builds the actual package using the cross-compilation environment:

1. **depend** - Resolves and builds package dependencies
2. **download** - Fetches source archives
3. **checksum** - Verifies archive integrity
4. **extract** - Unpacks source code
5. **patch** - Applies patches from the `patches/` directory
6. **configure** - Runs configure scripts (autotools, CMake, meson, etc.)
7. **compile** - Compiles the source code
8. **install** - Installs to the staging area
9. **plist** - Generates the package list

## SPK Package Assembly

For `spk/` packages, additional stages create the final SPK:

```mermaid
block
  columns 7
  depend space copy space strip space iconinfo["icon/info"]
  space space space space space space space
  spkfile["spk file"] space package space wizards space scripts

  depend --> copy
  copy --> strip
  strip --> iconinfo
  iconinfo --> scripts
  scripts --> wizards
  wizards --> package
  package --> spkfile
```

### SPK Assembly Steps

1. **depend** - Builds all dependencies listed in `DEPENDS`
2. **copy** - Copies dependency outputs to staging
3. **strip** - Strips debug symbols from binaries
4. **icon/info** - Processes icons and generates INFO file
5. **scripts** - Generates install/upgrade scripts from templates
6. **wizards** - Processes wizard templates (mustache format)
7. **package** - Creates `package.tgz` from staging area
8. **spk** - Assembles final `.spk` file

## Work Directory Structure

Each package build creates a work directory with consistent structure:

```
work-<arch>-<tcversion>/
├── <package>-<version>/     # Extracted source code
├── install/                  # Staging area for installation
│   └── var/packages/<pkg>/
│       └── target/           # Final package files
├── staging/                  # SPK assembly area
│   ├── package.tgz
│   ├── INFO
│   ├── scripts/
│   └── conf/
├── tc_vars.mk                # Toolchain variables
├── tc_vars.*.mk              # Build system adapters
└── .<stage>_done             # Cookie files
```

## Dependency Resolution

spksrc handles three types of dependencies:

### Build Dependencies (`DEPENDS`)

Listed in the Makefile, these are built before the current package:

```makefile
DEPENDS = cross/openssl cross/zlib
```

The framework recursively builds each dependency, installs it to the staging area, and makes it available to subsequent builds.

### Native Dependencies (`NATIVE_DEPENDS`)

Tools needed on the build host (not cross-compiled):

```makefile
NATIVE_DEPENDS = native/cmake
```

### Python Dependencies

Python packages use the wheel system for cross-compilation:

```makefile
WHEELS = src/requirements.txt
```

## Environment Configuration

The build environment is configured through layered includes:

1. **spksrc.common.mk** - Base settings and utilities
2. **spksrc.cross-env.mk** - Cross-compilation environment
3. **tc_vars.mk** - Toolchain-specific variables
4. **Build system specific** - CMake, meson, autotools adapters

### Environment Variables

The framework exports numerous variables to configure cross-compilation:

| Variable | Purpose |
|----------|--------|
| `CC`, `CXX` | Cross-compiler paths |
| `CFLAGS`, `CXXFLAGS` | Compiler flags |
| `LDFLAGS` | Linker flags |
| `PKG_CONFIG_PATH` | pkg-config search path |
| `STAGING_INSTALL_PREFIX` | Installation prefix |

## Parallel Build Support

spksrc supports parallel builds with three modes:

| Mode | Description |
|------|------------|
| `nop` | No parallel build (single job) |
| `max` | Use all available CPUs |
| `N` | Use exactly N parallel jobs |

Configure in `local.mk`:

```makefile
PARALLEL_MAKE = max
```

Or disable per-package:

```makefile
DISABLE_PARALLEL_MAKE = 1
```

## Build Logging

Build output is logged to:

- `build-<arch>-<tcversion>.log` - Main build log
- `status-<arch>-<tcversion>.log` - Status messages

The `MSG` macro provides consistent message formatting:

```makefile
@$(MSG) "Compiling $(NAME)"
```

## Related Documentation

- [Makefile System](makefile-system.md) - Detailed mk/*.mk documentation
- [Toolchains](toolchains.md) - Toolchain management details
- [Developer Guide: Build Workflow](../developer-guide/basics/build-workflow.md) - Using make targets
