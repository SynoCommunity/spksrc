# Makefile Variables

This page documents the Makefile variables used in spksrc packages.

!!! tip "Reference Documentation"
    For a complete reference of all variables and targets, see [Makefile Reference](../../reference/makefile-reference.md).

!!! warning "Include Order Matters"
    Any `ifeq` conditionals using architecture variables (like `ARMv7_ARCHS`, `x64_ARCHS`, etc.) must appear **after** `include ../../mk/spksrc.common.mk` or the relevant `spksrc.cross-*.mk` file. These variables are defined by the included makefiles and will be empty if referenced before the include.

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

### Configure Options

| Variable | Default | Description |
|----------|---------|-------------|
| `GNU_CONFIGURE` | 0 | Set to 1 for autoconf packages |
| `CMAKE_USE` | 0 | Set to 1 for CMake packages |
| `MESON_USE` | 0 | Set to 1 for Meson packages |
| `CONFIGURE_ARGS` | | Arguments passed to configure |
| `CMAKE_ARGS` | | Arguments passed to CMake |
| `MESON_ARGS` | | Arguments passed to Meson |

```makefile
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared --disable-static
CONFIGURE_ARGS += --with-ssl=$(STAGING_INSTALL_PREFIX)
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

### Make Options

| Variable | Description |
|----------|-------------|
| `MAKE_ARGS` | Arguments passed to make compile |
| `INSTALL_ARGS` | Arguments passed to make install |
| `INSTALL_TARGET` | Make target for installation (default: install) |

```makefile
MAKE_ARGS = DESTDIR=$(INSTALL_DIR)
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

| Group | Contains |
|-------|----------|
| `x64_ARCHS` | Intel 64-bit |
| `ARMv7_ARCHS` | ARM 32-bit |
| `ARMv7L_ARCHS` | ARM 32-bit low-end |
| `ARMv8_ARCHS` | ARM 64-bit |
| `ARM_ARCHS` | All ARM architectures |
| `PPC_ARCHS` | PowerPC |
| `32bit_ARCHS` | All 32-bit |
| `64bit_ARCHS` | All 64-bit |

## Path Variables (Available During Build)

| Variable | Description |
|----------|-------------|
| `WORK_DIR` | Package work directory |
| `PKG_DIR` | Extracted source directory |
| `INSTALL_DIR` | Installation destination |
| `STAGING_INSTALL_PREFIX` | Path prefix for installed files |
| `INSTALL_PREFIX` | Runtime prefix on NAS |
| `TC_PATH` | Toolchain path |
| `TC_INCLUDE` | Toolchain include path |
| `TC_LIBRARY` | Toolchain library path |

## SPK-Specific Variables

| Variable | Description |
|----------|-------------|
| `RELOAD_UI` | Set to `yes` to reload DSM UI after install |
| `BETA` | Set to `1` to mark as beta release |
| `SPK_ICON_256` | Path to 256x256 icon (optional) |
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

Install it in the Makefile:

```makefile
DSM_UI_DIR = app
ADMIN_PORT = 8080
ADMIN_URL = /admin

POST_STRIP_TARGET = mypackage_extra_install

.PHONY: mypackage_extra_install
mypackage_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
```
