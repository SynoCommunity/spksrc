# Build Rules

This page documents the build targets and rules available in spksrc.

## Build Targets

Run `make help` inside any package directory for the authoritative,
context-aware list. The tables below summarize the common targets.

### Cross Package Targets

Run from `cross/<package>/` directory:

| Target | Description |
|--------|-------------|
| `all` | Build everything (default; needs `ARCH=<arch> TCVERSION=<tcvers>`) |
| `arch-<arch>-<tcvers>` | Build for one arch/version (e.g. `arch-x64-7.2`) |
| `download` `checksum` `extract` `patch` `configure` `compile` `install` `plist` | Individual build lifecycle steps, in order |
| `all-supported` / `all-latest` | Build for every supported / latest toolchain (needs `make setup` first) |
| `dependency-tree` / `dependency-flat` / `dependency-list` | Inspect the dependency graph |
| `clean` | Remove all work directories |
| `smart-clean` | Remove this package's source and cookies (needs `ARCH`+`TCVERSION`) |
| `digests` | Regenerate the digests file (auto-runs `download`) |
| `rustup <args>` | Run rustup for the rust toolchain (e.g. `make rustup show`) |

### SPK Package Targets

Run from `spk/<package>/` directory (`diyspk/` behaves the same):

| Target | Description |
|--------|-------------|
| `all` | Build the SPK (default; needs `ARCH=<arch> TCVERSION=<tcvers>`) |
| `arch-<arch>-<tcvers>` | Build for one arch/version (e.g. `arch-x64-7.2`) |
| `all-supported` / `all-latest` | Build for every supported / latest toolchain (needs `make setup` first) |
| `package` | Create the SPK file |
| `dependency-tree` / `dependency-flat` / `dependency-list` | Inspect the dependency graph |
| `clean` / `smart-clean` | Remove work directories / this package's source and cookies |
| `download` / `digests` | Fetch source archive(s) / regenerate digests |
| `rustup <args>` | Run rustup for the rust toolchain (e.g. `make rustup show`) |

For Python SPKs (those setting `PYTHON_PACKAGE` or named `python3*`), additional
wheel/crossenv targets are available — see
[Python Packages](../package-types/python.md): `wheel-<arch>-<tcvers>`,
`crossenv-<arch>-<tcvers>`, `download-wheels`, `wheelclean`, `wheelcleancache`,
`crossenvclean`, `crossenvcleanall`.

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
```

For Python modules built as wheels under `python/` (numpy, pillow, ...), use
`spksrc.python-wheel.mk` (or `spksrc.python-wheel-meson.mk` for meson builds);
`spksrc.python-module.mk` builds a cross-compiled Python extension instead. See
[Python Packages](../package-types/python.md).

### SPK Packaging

```makefile
# Standard SPK
include ../../mk/spksrc.spk.mk

# Meta / Python-based SPK: set the *_PACKAGE (and WHEELS) and include
# spksrc.spk-meta.mk, which pulls in the matching meta + wheel routines
PYTHON_PACKAGE = python312
WHEELS = src/requirements-crossenv.txt
include ../../mk/spksrc.spk-meta.mk
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
