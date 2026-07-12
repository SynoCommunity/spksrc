# Makefile Variables

This page documents the Makefile variables used in spksrc packages.

!!! tip "Reference Documentation"
    For a complete reference of all variables and targets, see [Makefile Reference](../../reference/makefile-reference.md).

!!! warning "Include Order Matters"
    Architecture variables (`ARMv7_ARCHS`, `x64_ARCHS`, etc.) and the helper macros are defined by `spksrc.common.mk`, which loads the architecture classification and macros early (see [Macros](../../reference/macros.md)). Any `ifeq` using them must therefore appear **after** `include ../../mk/spksrc.common.mk` (or the relevant `spksrc.cross-*.mk`, which includes it) — referenced before the include they are empty.

## Package Identification

### Cross Packages

| Variable | Required | Description |
|----------|----------|-------------|
| `PKG_NAME` | Yes | Package name (lowercase, hyphens) |
| `PKG_VERS` | Yes | Package version |
| `PKG_EXT` | Yes | Source file extension (tar.gz, tar.xz, zip) |
| `PKG_DIST_NAME` | Yes | Source filename to download |
| `PKG_DIST_SITE` | Yes | Base URL for download |
| `PKG_DIR` | Yes | Directory name after extraction |

Example:

```makefile
PKG_NAME = curl
PKG_VERS = 8.4.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://curl.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
```

### SPK Packages

| Variable | Required | Description |
|----------|----------|-------------|
| `SPK_NAME` | Yes | Package name shown in Package Center |
| `SPK_VERS` | Yes | Version displayed to users |
| `SPK_REV` | Yes | Revision number (increment for each release) |
| `SPK_ICON` | No | Path to package icon (256x256+ PNG, auto-resized) |

## Metadata

| Variable | Required | Description |
|----------|----------|-------------|
| `HOMEPAGE` | No | Project website |
| `COMMENT` | Yes | Short description |
| `LICENSE` | Yes | License name (GPLv2, MIT, etc.) |
| `LICENSE_FILE` | No | Path to license agreement file |
| `MAINTAINER` | Yes | Package maintainer name |
| `DESCRIPTION` | SPK only | Full description for Package Center |
| `DISPLAY_NAME` | SPK only | Display name in Package Center |
| `CHANGELOG` | SPK only | Changes in this version |

## Dependencies

### Build Dependencies

| Variable | Description |
|----------|-------------|
| `DEPENDS` | Cross packages to build/include |
| `BUILD_DEPENDS` | Packages needed only for building |
| `NATIVE_DEPENDS` | Native tools needed for building |

```makefile
# Include these in the SPK
DEPENDS = cross/curl cross/openssl

# Only needed during build
BUILD_DEPENDS = native/cmake
```

### SPK Dependencies

| Variable | Description |
|----------|-------------|
| `SPK_DEPENDS` | Other SPK packages required at runtime |
| `SPK_CONFLICT` | Packages that conflict with this one |

```makefile
# Requires WebStation to be installed
SPK_DEPENDS = "WebStation>=3.0"

# Cannot be installed alongside
SPK_CONFLICT = "transmission"
```

## Build Configuration

These variables apply to `cross/` package Makefiles.

### Build System Selection

A cross package's build system is chosen by which `mk/spksrc.cross-*.mk` it includes; the arguments are then passed through the matching variable:

| Build system | Include | Arguments variable |
|--------------|---------|--------------------|
| autotools | `spksrc.cross-cc.mk` + `GNU_CONFIGURE = 1` | `CONFIGURE_ARGS` |
| CMake | `spksrc.cross-cmake.mk` | `CONFIGURE_ARGS` |
| Meson | `spksrc.cross-meson.mk` | `CONFIGURE_ARGS` (passed to `meson setup`) |

All three build systems also honour `ADDITIONAL_CONFIGURE_ARGS`, appended right
after `CONFIGURE_ARGS` on the configure/cmake/`meson setup` command line. It is
never set by the framework. Prefer `CONFIGURE_ARGS +=`; reach for
`ADDITIONAL_CONFIGURE_ARGS` only when a package reuses `CONFIGURE_ARGS` for its
own extra configure invocations and needs args that go to the framework's
invocation *only* (see `cross/x265`, whose 10/12-bit sub-builds share
`CONFIGURE_ARGS` but must not receive the final-build link flags).

```makefile
# autotools
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared --disable-static
CONFIGURE_ARGS += --with-ssl=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
```

```makefile
# Meson (CONFIGURE_ARGS is forwarded to `meson setup`)
CONFIGURE_ARGS = -Dtests=disabled

include ../../mk/spksrc.cross-meson.mk
```

### Compiler Flags

| Variable | Description |
|----------|-------------|
| `ADDITIONAL_CFLAGS` | Extra C compiler flags |
| `ADDITIONAL_CXXFLAGS` | Extra C++ compiler flags |
| `ADDITIONAL_CPPFLAGS` | Extra preprocessor flags |
| `ADDITIONAL_LDFLAGS` | Extra linker flags |

```makefile
ADDITIONAL_CFLAGS = -O3 -DNDEBUG
ADDITIONAL_LDFLAGS = -Wl,-rpath,/var/packages/mypackage/target/lib
```

### Compile and Install Arguments

`COMPILE_ARGS` carries extra arguments for the compile step across every build system. For autotools / plain GNU make it is the make command; for CMake and Meson it is appended as-is to `cmake --build` and `ninja` respectively.

| Variable | Description |
|----------|-------------|
| `COMPILE_ARGS` | Extra arguments for the compile step (make / cmake --build / ninja) |
| `INSTALL_MAKE_OPTIONS` | Extra arguments passed to `make` at install |
| `INSTALL_TARGET` | Make target for installation (default: install) |

```makefile
COMPILE_ARGS = V=1
INSTALL_TARGET = install-strip
```

## Service Configuration

These variables apply to `spk/` package Makefiles.

| Variable | Description |
|----------|-------------|
| `STARTABLE` | `yes` if package has a service to start |
| `SERVICE_USER` | `auto` to create `sc-<packagename>` user (required for DSM 7) |
| `SERVICE_SETUP` | Path to service-setup.sh |
| `SERVICE_PORT` | Port used by the service |
| `SERVICE_PORT_TITLE` | Label for the port |
| `SERVICE_WIZARD_SHARENAME` | Wizard share variable for shared folder |
| `FWPORTS` | Path to firewall port configuration file |
| `SPK_COMMANDS` | List of `bin/command` paths for `/usr/local/bin` symlinks |

```makefile
STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8080
SERVICE_PORT_TITLE = Web Interface

# Firewall ports (creates resource entry)
FWPORTS = src/mypackage.sc

# Commands to link to /usr/local/bin
SPK_COMMANDS = bin/mycommand bin/myother
```

## Architecture Support

| Variable | Description |
|----------|-------------|
| `UNSUPPORTED_ARCHS` | Architectures that cannot build this package |
| `REQUIRED_MIN_DSM` | Minimum DSM version required |
| `OS_MIN_VER` | Minimum OS version (alternative to above) |

```makefile
# Only works on 64-bit
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

# Requires DSM 7.0+
REQUIRED_MIN_DSM = 7.0
```

### Architecture Groups

spksrc provides groups such as `x64_ARCHS`, `ARMv7_ARCHS`, `ARMv8_ARCHS`, `ARM_ARCHS`, `PPC_ARCHS`, `32bit_ARCHS` and `64bit_ARCHS`. The complete, authoritative list (with the platform codenames each contains) is in [Reference: Architectures](../../reference/architectures.md#architecture-groups).

Use them in `ifeq` to enable code per architecture. The groups are available **after** including a spksrc entry point (or `spksrc.common.mk`):

```makefile
include ../../mk/spksrc.common.mk

# Only build a feature on 64-bit targets
ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-feature
endif

# x64-only dependency
ifneq ($(findstring $(ARCH),$(x64_ARCHS)),)
DEPENDS += cross/intel-media-driver
endif

# Exclude a whole family from the build
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)
```

### Version Conditions

The `version_*` [macros](../../reference/macros.md#version-comparison) gate code on a toolchain (or any version) — they return `1` when true:

```makefile
include ../../mk/spksrc.common.mk

# Newer toolchains only
ifeq ($(call version_ge,$(TC_GCC),12),1)
DEPENDS += cross/libplacebo
endif

# Workaround for old compilers
ifeq ($(call version_lt,$(TC_GCC),5.0),1)
ADDITIONAL_CFLAGS += -std=gnu99
endif
```

## Path Variables (Available During Build)

| Variable | Description |
|----------|-------------|
| `WORK_DIR` | Package work directory |
| `PKG_DIR` | Extracted source directory |
| `INSTALL_DIR` | Installation destination |
| `STAGING_INSTALL_PREFIX` | Path prefix for installed files |
| `INSTALL_PREFIX` | Runtime prefix on NAS |

## SPK-Specific Variables

| Variable | Description |
|----------|-------------|
| `ADMIN_PORT` | Port for admin interface |
| `ADMIN_PROTOCOL` | Protocol (http/https) for admin interface |
| `ADMIN_URL` | Custom admin URL path |

```makefile
ADMIN_PORT = 8080
ADMIN_PROTOCOL = http
ADMIN_URL = /mypackage
```

## Web Interface Shortcuts

Packages with web interfaces can add a shortcut icon to the DSM main menu. For the complete list of variables, see the [Makefile Reference](../../reference/makefile-reference.md#web-interface-variables).

### Automatic Generation (Recommended)

Use `SERVICE_PORT` to automatically generate the shortcut:

```makefile
DSM_UI_DIR = app
SERVICE_PORT = 8096
SERVICE_PORT_TITLE = My App (HTTP)
ADMIN_PORT = $(SERVICE_PORT)
```

### Custom Configuration

For custom URL paths or descriptions, create `src/app/config`:

```json
{
    ".url": {
        "com.synocommunity.packages.<pkgname>": {
            "title": "Package Name",
            "desc": "Tooltip description",
            "icon": "images/<pkgname>-{0}.png",
            "type": "url",
            "protocol": "http",
            "port": "8080",
            "url": "/admin",
            "allUsers": true
        }
    }
}
```

Point `DSM_UI_CONFIG` at that file — the framework installs it as the package's `app/config`, overriding the auto-generated one:

```makefile
DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
ADMIN_PORT = 8080
ADMIN_URL = /admin
```
