# Packaging Guide

This section covers the details of creating and configuring spksrc packages.

## Overview

Creating a package involves:

1. Writing Makefiles that describe how to build the software
2. Configuring package metadata and dependencies
3. Setting up services and installation wizards
4. Testing and validating the package

## Package Types

spksrc supports several package categories:

### Cross Packages (`cross/`)

Software compiled for the target NAS architecture:

- Libraries (openssl, zlib, curl)
- Command-line tools (git, screen)
- Server applications (nginx, ffmpeg)

### SPK Packages (`spk/`)

Final packages installed via Package Center:

- Bundle one or more cross packages
- Include configuration, services, and UI
- Produce `.spk` files

### Native Packages (`native/`)

Tools built for the build host:

- Used during the build process
- Not included in final packages
- Example: cmake, ninja

## In This Section

- **[Makefile Variables](makefile-variables.md)** - Common variables and their meanings
- **[Build Rules](build-rules.md)** - Build targets and customization
- **[PLIST Files](plist.md)** - Defining package contents
- **[Service Scripts](service-scripts.md)** - Daemons and services
- **[Wizards](wizards.md)** - Installation wizards
- **[Resource Files](resource-files.md)** - DSM 7 resource configuration

## Quick Start: Creating a Package

### 1. Create Cross Package

```bash
mkdir -p cross/mypackage
```

Create `cross/mypackage/Makefile`:

```makefile
PKG_NAME = mypackage
PKG_VERS = 1.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://example.com/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://example.com
COMMENT  = My awesome package
LICENSE  = MIT

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
```

Create `cross/mypackage/digests`:

```
mypackage-1.0.0.tar.gz SHA1 abc123...
mypackage-1.0.0.tar.gz SHA256 def456...
mypackage-1.0.0.tar.gz MD5 ghi789...
```

### 2. Create SPK Package

```bash
mkdir -p spk/mypackage
```

Create `spk/mypackage/Makefile`:

```makefile
SPK_NAME = mypackage
SPK_VERS = 1.0.0
SPK_REV = 1
SPK_ICON = src/mypackage.png

DEPENDS = cross/mypackage

MAINTAINER = YourName
DESCRIPTION = My awesome package for Synology
DISPLAY_NAME = MyPackage
CHANGELOG = "Initial release"

HOMEPAGE = https://example.com
LICENSE  = MIT

include ../../mk/spksrc.spk.mk
```

### 3. Build and Test

```bash
make -C spk/mypackage ARCH=x64 TCVERSION=7.2
```

## Common Patterns

### Adding Dependencies

```makefile
# Cross package dependencies
DEPENDS = cross/zlib cross/openssl

# SPK dependencies (installed packages)
SPK_DEPENDS = "WebStation>=3.0"
```

### Applying Patches

Place patches in `patches/` directory:

```
cross/mypackage/
└── patches/
    ├── 001-fix-build.patch
    └── 002-add-feature.patch
```

Patches are applied in alphabetical order.

### Custom Build Steps

```makefile
# Run before configure
pre_configure_target:
	cp myconfig.h $(WORK_DIR)/$(PKG_DIR)/

# Run after install
post_install_target:
	@$(MSG) Installing extra files
	cp -r extra/* $(STAGING_INSTALL_PREFIX)/
```

### Per-Architecture Settings

```makefile
# Architecture variables require the common include first
include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
  CONFIGURE_ARGS += --enable-arm-optimizations
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
  CONFIGURE_ARGS += --enable-x86-optimizations
endif
```

## Best Practices

1. **Keep it simple** - Use standard build systems when possible
2. **Document changes** - Update CHANGELOG for each release
3. **Test multiple architectures** - Build for at least x64 and aarch64
4. **Follow naming conventions** - Use lowercase, hyphens for package names
5. **Pin dependencies** - Specify minimum versions when needed
6. **Check licenses** - Ensure license compatibility
