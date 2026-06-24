# Build Rules

This page documents the build targets and rules available in spksrc.

## Build Targets

### Cross Package Targets

Run from `cross/<package>/` directory:

| Target | Description |
|--------|-------------|
| `all` | Build everything (default) |
| `download` | Download source archive |
| `checksum` | Verify checksums |
| `extract` | Extract source archive |
| `patch` | Apply patches |
| `configure` | Run configure script |
| `compile` | Compile the source |
| `install` | Install to staging |
| `plist` | Generate PLIST file |
| `clean` | Remove build artifacts |

### SPK Package Targets

Run from `spk/<package>/` directory:

| Target | Description |
|--------|-------------|
| `all` | Build SPK (default) |
| `arch-<arch>-<version>` | Build for specific architecture (e.g., `arch-x64-7.2`) |
| `all-supported` | Build for all architectures in `DEFAULT_TC` |
| `package` | Create SPK file |
| `publish` | Publish to package server |
| `clean` | Remove build artifacts |

## Build System Includes

### Cross Compilation

```makefile
# Standard C/C++ package
include ../../mk/spksrc.cross-cc.mk

# CMake package
include ../../mk/spksrc.cross-cmake.mk

# Meson package
include ../../mk/spksrc.cross-meson.mk

# Go package
include ../../mk/spksrc.cross-go.mk

# Rust package
include ../../mk/spksrc.cross-rust.mk

# Python wheel
include ../../mk/spksrc.python-module.mk
```

### SPK Packaging

```makefile
# Standard SPK
include ../../mk/spksrc.spk.mk

# Python-based SPK
include ../../mk/spksrc.python.mk
```

## Customization Hooks

Override these targets to add custom behavior:

### Pre/Post Hooks

```makefile
# Before each stage
pre_download_target:
	@echo "Preparing download..."

pre_extract_target:
	@echo "Preparing extraction..."

pre_patch_target:
	@echo "Before patching..."

pre_configure_target:
	@echo "Before configure..."

pre_compile_target:
	@echo "Before compile..."

pre_install_target:
	@echo "Before install..."

# After each stage
post_extract_target:
	@echo "After extraction..."

post_patch_target:
	@echo "After patching..."

post_configure_target:
	@echo "After configure..."

post_compile_target:
	@echo "After compile..."

post_install_target:
	@echo "After install..."
```

### Custom Install

```makefile
# Override the entire install stage
install_target:
	@$(MSG) "Custom install"
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	cp $(WORK_DIR)/$(PKG_DIR)/mybin $(STAGING_INSTALL_PREFIX)/bin/
```

## Build Types

### GNU Autoconf

```makefile
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared --disable-static

include ../../mk/spksrc.cross-cc.mk
```

This will run:
```
./configure --host=$(TC_TARGET) --prefix=$(INSTALL_PREFIX) $(CONFIGURE_ARGS)
```

### CMake

```makefile
CMAKE_ARGS = -DBUILD_SHARED_LIBS=ON

include ../../mk/spksrc.cross-cmake.mk
```

The `spksrc.cross-cmake.mk` include automatically sets up the CMake build environment.

### Meson

```makefile
include ../../mk/spksrc.cross-meson.mk
```

### Custom Build System

```makefile
# Disable auto-configure
CONFIGURE_TARGET = nop

# Custom compile
compile_target:
	$(MAKE) -C $(WORK_DIR)/$(PKG_DIR) CC=$(TC_PATH)gcc

# Custom install
install_target:
	$(MAKE) -C $(WORK_DIR)/$(PKG_DIR) PREFIX=$(STAGING_INSTALL_PREFIX) install

include ../../mk/spksrc.cross-cc.mk
```

## Architecture-Specific Rules

```makefile
# Different settings per architecture
ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-neon
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-sse4
endif

# Exclude architectures
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
@$(error This package does not support PowerPC)
endif
```

## Environment Variables

Available during build:

| Variable | Description |
|----------|-------------|
| `CC` | C compiler |
| `CXX` | C++ compiler |
| `LD` | Linker |
| `AR` | Archiver |
| `STRIP` | Strip command |
| `RANLIB` | Ranlib command |
| `CFLAGS` | C compiler flags |
| `CXXFLAGS` | C++ compiler flags |
| `CPPFLAGS` | Preprocessor flags |
| `LDFLAGS` | Linker flags |
| `PKG_CONFIG_PATH` | pkg-config search path |

## Debugging

```makefile
# Print a message during build
	@$(MSG) "Building for $(ARCH)"

# Print variable value
	@echo "STAGING_INSTALL_PREFIX = $(STAGING_INSTALL_PREFIX)"

# Fail with error
	@$(error "This configuration is not supported")
```

From command line:

```bash
# Verbose output
make V=1 ARCH=x64 TCVERSION=7.2

# Dry run (show commands)
make -n ARCH=x64 TCVERSION=7.2

# Debug makefile parsing
make -d ARCH=x64 TCVERSION=7.2
```

## Further Reading

For details on how the build system works internally:

- [Framework: Makefile System](../../framework/makefile-system.md) - Deep dive into mk/*.mk files
- [Framework: Architecture](../../framework/architecture.md) - Build pipeline internals
