# Toolchain Management

This document describes how spksrc manages Synology cross-compilation toolchains.

## Overview

Synology provides official cross-compilation toolchains for each DSM version and architecture. spksrc downloads, extracts, and configures these toolchains automatically.

## Toolchain Directory Structure

```
toolchain/
├── syno-x64-7.2/
│   ├── Makefile
│   ├── digests
│   └── work/
│       ├── x86_64-pc-linux-gnu/    # Extracted toolchain
│       ├── tc_vars.mk              # Generated variables
│       ├── tc_vars.autotools.mk
│       ├── tc_vars.flags.mk
│       ├── tc_vars.cmake
│       └── tc_vars.meson-*
├── syno-aarch64-7.2/
├── syno-armv7-7.2/
└── ...
```

## Toolchain Naming

Toolchains follow the pattern `syno-<arch>-<tcversion>`:

- **arch** - Target architecture (x64, aarch64, armv7, etc.)
- **tcversion** - DSM version (7.2, 7.1, 6.2.4, etc.)

Examples:
- `syno-x64-7.2` - Intel 64-bit for DSM 7.2
- `syno-aarch64-7.1` - ARM 64-bit for DSM 7.1
- `syno-armv7-6.2.4` - ARM 32-bit for DSM 6.2.4

## Toolchain Makefile

Each toolchain directory contains a Makefile with:

```makefile
TC_NAME  = x86_64-pc-linux-gnu
TC_VERS  = 7.2
TC_ARCH  = x64
TC_DIST_SITE_PATH = $(SYNOLOGY_DOWNLOAD_URL)/toolchain/DSM$(TC_VERS)
TC_DIST_NAME = $(TC_DIST_SITE_PATH)/Intel%20x86%20Linux%204.4.302%20%28x86_64-GPL%29.txz

include ../../mk/spksrc.toolchain.mk
```

## tc_vars Files

The toolchain build generates several `tc_vars*.mk` files that configure cross-compilation:

### tc_vars.mk

Core toolchain identity:

```makefile
TC_NAME     = x86_64-pc-linux-gnu
TC_PREFIX   = /path/to/toolchain/work/x86_64-pc-linux-gnu/bin/
TC_PATH     = $(TC_PREFIX)/bin
TC_SYSROOT  = $(TC_PREFIX)/x86_64-pc-linux-gnu/sysroot
TC_CC       = $(TC_PREFIX)x86_64-pc-linux-gnu-gcc
TC_CXX      = $(TC_PREFIX)x86_64-pc-linux-gnu-g++
TC_AR       = $(TC_PREFIX)x86_64-pc-linux-gnu-ar
TC_LD       = $(TC_PREFIX)x86_64-pc-linux-gnu-ld
TC_STRIP    = $(TC_PREFIX)x86_64-pc-linux-gnu-strip
```

### tc_vars.autotools.mk

Autotools (configure) adapter:

```makefile
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --host=$(TC_NAME) --build=$(TC_BUILD)
```

### tc_vars.flags.mk

Compiler and linker flags:

```makefile
CFLAGS   = -I$(STAGING_INSTALL_PREFIX)/include
CXXFLAGS = $(CFLAGS)
LDFLAGS  = -L$(STAGING_INSTALL_PREFIX)/lib -Wl,-rpath,$(INSTALL_PREFIX)/lib
```

### tc_vars.cmake

CMake toolchain file for cross-compilation:

```cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_C_COMPILER /path/to/x86_64-pc-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER /path/to/x86_64-pc-linux-gnu-g++)
set(CMAKE_SYSROOT /path/to/sysroot)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
```

### tc_vars.meson-cross and tc_vars.meson-native

Meson cross and native files:

```ini
# tc_vars.meson-cross
[binaries]
c = '/path/to/x86_64-pc-linux-gnu-gcc'
cpp = '/path/to/x86_64-pc-linux-gnu-g++'
ar = '/path/to/x86_64-pc-linux-gnu-ar'
strip = '/path/to/x86_64-pc-linux-gnu-strip'
pkgconfig = '/usr/bin/pkg-config'

[host_machine]
system = 'linux'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'
```

### tc_vars.rust.mk

Rust cross-compilation settings:

```makefile
CARGO_TARGET = x86_64-unknown-linux-gnu
RUSTFLAGS = -C linker=$(TC_CC)
```

## Supported Architectures

spksrc supports the following architecture families:

### 64-bit Architectures

| Architecture | CPU Family | Common Models |
|-------------|------------|---------------|
| x64 | Intel 64-bit | DS923+, DS1621+, RS1221+ |
| aarch64 | ARM 64-bit | DS223, DS423+, RS422+ |

### 32-bit Architectures (Legacy)

| Architecture | CPU Family | Common Models |
|-------------|------------|---------------|
| armv7 | ARM 32-bit | DS218, DS418 |
| i686 | Intel 32-bit | DS216j, DS218j |

### Generic Architectures

Generic architectures build for multiple targets:

| Generic | Expands To |
|---------|------------|
| arm5 | 88f6281, 88f6282 |
| arm7 | alpine, alpine4k, armada370, armada375, armada38x, armadaxp, comcerto2k, monaco |
| arm8 | rtd1296, rtd1619b, armv8 |
| ppc | ppc853x, ppc854x, qoriq |

## Adding New Toolchain Support

When Synology releases a new DSM version:

1. **Create toolchain directory**:
   ```bash
   mkdir toolchain/syno-x64-8.0
   ```

2. **Create Makefile**:
   ```makefile
   TC_NAME  = x86_64-pc-linux-gnu
   TC_VERS  = 8.0
   TC_ARCH  = x64
   TC_DIST_SITE_PATH = $(SYNOLOGY_DOWNLOAD_URL)/toolchain/DSM$(TC_VERS)
   TC_DIST_NAME = $(TC_DIST_SITE_PATH)/Intel%20x86%20Linux%20...%20%28x86_64-GPL%29.txz
   
   include ../../mk/spksrc.toolchain.mk
   ```

3. **Create digests file** with SHA256 checksums

4. **Test build**:
   ```bash
   make -C spk/transmission ARCH=x64 TCVERSION=8.0
   ```

## Toolchain Build Process

The toolchain build follows this process:

1. **Download** - Fetches toolchain archive from Synology
2. **Checksum** - Verifies archive integrity
3. **Extract** - Unpacks to `work/` directory
4. **Normalize** - Applies patches for compatibility
5. **Rust** - Installs Rust toolchain components if needed
6. **tcvars** - Generates tc_vars*.mk files

## Caching

Toolchains are cached in the `distrib/` directory:

```
distrib/
└── toolchain/
    ├── Intel x86 Linux 4.4.302 (x86_64-GPL).txz
    ├── Realtek RTD1296 Linux 4.4.180 (aarch64-GPL).txz
    └── ...
```

Once downloaded, toolchains are reused across builds. Delete from `distrib/` to force re-download.

## Troubleshooting

### Toolchain Download Fails

Check if the URL is still valid:
```bash
grep TC_DIST_NAME toolchain/syno-x64-7.2/Makefile
# Verify URL accessibility
```

### tc_vars Not Generated

Remove the tcvars cookie and rebuild:
```bash
rm toolchain/syno-x64-7.2/work/.tcvars_done
make -C toolchain/syno-x64-7.2 tcvars
```

### Cross-Compiler Not Found

Ensure the toolchain is fully extracted:
```bash
ls toolchain/syno-x64-7.2/work/x86_64-pc-linux-gnu/bin/
```

## Related Documentation

- [Architecture](architecture.md) - Build pipeline overview
- [Makefile System](makefile-system.md) - mk/*.mk file details
- [Reference: Architectures](../reference/architectures.md) - Complete architecture reference
