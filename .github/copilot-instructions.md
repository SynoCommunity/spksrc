# spksrc - SynoCommunity Package Framework

spksrc is a cross-compilation framework for building software packages (SPK) for Synology NAS devices. It supports multiple CPU architectures (x64, ARM, PPC) and DSM versions (5.2, 6.2, 7.1, 7.2) as well as SRM (Synology Router Manager).

> **Note:** DSM 7.3 is the latest Synology release but toolchains/toolkits are not yet available. DSM 7.1 is the SynoCommunity default and is compatible with DSM 7.1 through 7.3.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information.

## Repository Structure

```
cross/          - Cross-compiled packages (libraries and applications)
diyspk/         - Do-it-yourself SPK templates for standalone versions of bundled packages
native/         - Native build tools (compiled for the build host)
spk/            - SPK package definitions (final installable packages)
python/         - Python wheel packages
toolchain/      - Synology toolchain definitions
toolkit/        - Synology toolkit definitions
kernel/         - Synology modified kernel sources for building modules
mk/             - Makefile framework (spksrc.*.mk files)
distrib/        - Downloaded source archives (cached)
packages/       - Built SPK output files
.github/        - GitHub Actions workflows and templates
```

## Working Effectively

### Development Environment Setup

**Docker (Recommended)**:
```bash
# Clone and enter repository
git clone https://github.com/SynoCommunity/spksrc
cd spksrc

# Run the spksrc Docker container
docker pull ghcr.io/synocommunity/spksrc
docker run -it --platform=linux/amd64 -v $(pwd):/spksrc -w /spksrc ghcr.io/synocommunity/spksrc /bin/bash

# Inside container, run initial setup
make setup              # Basic setup with default toolchains
# OR
make setup-synocommunity  # Setup with SynoCommunity defaults (publish URL, distributor info)
```

For detailed Docker setup and LXC/LXD alternatives, see the [Developers HOW-TO](https://github.com/SynoCommunity/spksrc/wiki/Developers-HOW-TO).

> **Note:** Native Linux builds are not officially supported. Use Docker or LXC/LXD with Debian to match the build environment.

### Building Packages

**Initial setup** (required once):
```bash
make setup              # Creates local.mk with default toolchains (DSM 6.2.4, 7.1)
```

**Build a single SPK package for a specific architecture**:
```bash
cd spk/packagename
make arch-x64-7.2        # Build for specific arch/DSM version
make all-supported       # Build for all officially supported architectures
make all-latest          # Build for latest DSM version per architecture
```

**Parallel builds** (2D parallelism):
```bash
# Build 4 architectures in parallel, each using max CPU cores
PARALLEL_MAKE=max make -j4 all-supported
```

This leverages two factors: `-j<N>` controls how many architectures build concurrently, while `PARALLEL_MAKE` controls cores per build. Works well because different archs progress at different rates (configure vs compile phases).

> **Note:** For very large packages like LLVM, build one architecture at a time.

**Common make targets**:
- `make arch-<arch>-<version>` - Build for specific architecture
- `make all-supported` - Build for all supported architectures
- `make all-latest` - Build for latest DSM version per architecture
- `make clean` - Clean build artifacts
- `make digests` - Regenerate source file checksums
- `make dependency-tree` - Show package dependency tree

### Architecture Reference

**DSM 7.2**: `x64-7.2`, `aarch64-7.2`, `armv7-7.2`
**DSM 7.1** (default): `x64-7.1`, `aarch64-7.1`, `armv7-7.1`, `evansport-7.1`, `comcerto2k-7.1`
**DSM 6.2.4**: `x64-6.2.4`, `aarch64-6.2.4`, `armv7-6.2.4`, `88f6281-6.2.4`, `qoriq-6.2.4`
**DSM 5.2** (legacy): `x86-5.2`, `88f6281-5.2`, `ppc853x-5.2`
**SRM 1.3**: `aarch64-1.3`, `armv7-1.3`

**Architecture groups** (defined in `mk/spksrc.common/archs.mk`):
- `x64_ARCHS` - 64-bit Intel/AMD
- `ARMv8_ARCHS` - 64-bit ARM (aarch64)
- `ARMv7_ARCHS` - 32-bit ARM
- `ARMv7L_ARCHS` - Legacy 32-bit ARM (hi3535)
- `ARMv5_ARCHS` - Legacy ARM (88f6281)
- `PPC_ARCHS` - PowerPC (qoriq, ppc853x, etc.)
- `OLD_PPC_ARCHS` - Deprecated PPC (ppc853x, powerpc, ppc824x, ppc854x)
- `32bit_ARCHS` - All 32-bit architectures
- `64bit_ARCHS` - All 64-bit architectures

The bitness groups are useful for packages requiring arch-specific flags without autotools/cmake/meson detection.

## Package Development

### Cross Package Structure (cross/packagename/)

```
cross/packagename/
├── Makefile           # Package definition
├── digests            # SHA256 checksums for source files
├── PLIST              # List of installed files (optional)
└── patches/           # Patches to apply (optional)
    ├── 001-fix.patch
    └── archname/      # Arch-specific patches
        └── 001-arch-specific.patch
```

**Example cross/Makefile**:
```makefile
PKG_NAME = example
PKG_VERS = 1.2.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://example.com/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/dependency1 cross/dependency2

HOMEPAGE = https://example.com
COMMENT  = Short description
LICENSE  = MIT
LICENSE_FILE = LICENSE   # Optional: prompts user to accept license at install

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-docs

include ../../mk/spksrc.cross-cc.mk
```

**Build system includes** (master Makefile is `spksrc.cross-cc.mk`):
- `spksrc.cross-cc.mk` - Autotools/configure based builds (main entry point)
- `spksrc.cross-cmake.mk` - CMake builds
- `spksrc.cross-meson.mk` - Meson builds
- `spksrc.cross-go.mk` - Go builds
- `spksrc.cross-rust.mk` - Rust/Cargo builds

All other build system includes eventually call `cross-cc.mk`, which normalizes configure/compile/install steps.

**Meta cross-compiling rulesets** (for pre-built package integration):
- `spksrc.python.mk` - Python packages (adds python312/311 library paths)
- `spksrc.ffmpeg.mk` - FFmpeg integration (adds ffmpeg library paths)
- `spksrc.videodriver.mk` - Video driver support

These add library include paths and RPATH definitions so binaries can find dependencies at runtime (e.g., `/var/packages/python312/target/lib`).

**Python multi-version packages**:
Packages can use conditional `PYTHON_PACKAGE` for different architectures (e.g., python311 for ARMv5/ARMv7L, python312 for others):
```makefile
# Include common.mk first for arch variable definitions
include ../../mk/spksrc.common.mk

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS)),)
PYTHON_PACKAGE = python311
else
PYTHON_PACKAGE = python312
endif

include ../../mk/spksrc.python.mk
```
Use arch-specific requirements files (e.g., `requirements-crossenv-armv5.txt`) when wheel versions differ by architecture.

**Python wheel types and requirements files**:
Python packages fall into four categories, each with a corresponding requirements file:

| Type | Requirements File | Description |
|------|------------------|-------------|
| Pure-python | `requirements-pure.txt` | Platform-independent, no compilation needed |
| Cross-compiled | `requirements-crossenv.txt` | C-extensions, compiled via Python crossenv |
| ABI3-limited | `requirements-abi3.txt` | Limited API/ABI for broader compatibility |
| Cross-package | `requirements-cross.txt` | Auto-generated from `cross/*` packages |

All requirements must pin exact versions (e.g., `mercurial==6.5.1`). Do not include `setuptools`, `pip`, or `wheel`.

**Identifying wheel types**:
- Pure-python wheels end with `py3-none-any.whl`
- Cross-compiled wheels end with architecture suffix like `cp312-cp312-linux_x86_64.whl`
- If a pure-python build fails with `gcc` errors, the package needs cross-compilation

**Cross-compiled wheels** (packages with C-extensions):
1. Create `cross/packagename/` with `include ../../mk/spksrc.python-wheel.mk`
2. Add `BUILD_DEPENDS = cross/python312` to the SPK Makefile
3. Add `cross/packagename` to `DEPENDS` or `BUILD_DEPENDS`
4. Wheels are built in `work-*/wheelhouse/` and copied to `share/wheelhouse/`

**Source URL patterns**:
The framework automatically rewrites certain URLs to use mirrors:
- `ftp.gnu.org` → `ftpmirror.gnu.org`
- `sourceforge.net/projects/*/files/` → `downloads.sourceforge.net/project/*/`

For non-standard source filenames (common with GitHub), use `PKG_DIST_FILE` to rename:
```makefile
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
```

### SPK Package Structure (spk/packagename/)

```
spk/packagename/
├── Makefile           # SPK definition
└── src/
    ├── packagename.png      # Icon (ideally 512x512, framework scales down)
    ├── service-setup.sh     # Service configuration
    ├── wizard/              # Installation wizard pages (optional)
    └── conf/                # Configuration files (optional)
```

**Example spk/Makefile**:
```makefile
SPK_NAME = example
SPK_VERS = 1.2.3
SPK_REV = 1
SPK_ICON = src/example.png

DEPENDS = cross/example

MAINTAINER = username
DESCRIPTION = "Package description for DSM Package Center."
DISPLAY_NAME = Example Package

CHANGELOG = "Initial release."

HOMEPAGE = https://example.com
LICENSE  = MIT

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8080
SERVICE_PORT_TITLE = Example Web UI

include ../../mk/spksrc.spk.mk
```

### Versioning Rules

- `SPK_VERS` - Upstream version (e.g., 1.2.3)
- `SPK_REV` - Package revision, starts at 1, always increment for any change
- Never reset or decrement `SPK_REV` - always increment, even when `SPK_VERS` changes
- Increment `SPK_REV` for dependency updates, patches, or fixes

### Creating Patches

Patches use unified diff format with `-p0` (no leading directory):

```bash
# Generate a patch
diff -u original_file modified_file > patches/001-description.patch

# Patch format for -p0 application:
--- path/to/file.c
+++ path/to/file.c
@@ -10,6 +10,7 @@
 context line
-removed line
+added line
 context line
```

**Arch-specific patches**: Place in `patches/archname/` subdirectory.

### Digests File

Contains SHA1, SHA256, and MD5 checksums for source downloads:
```
packagename-1.2.3.tar.gz SHA1 abc123...
packagename-1.2.3.tar.gz SHA256 def456...
packagename-1.2.3.tar.gz MD5 789ghi...
```

Regenerate with: `make digests`

## Validation

### Testing Builds

```bash
# Test build for a specific architecture
cd spk/packagename
make arch-x64-7.2

# Check the output
ls -la ../../packages/*.spk

# Clean and rebuild
make clean
make arch-x64-7.2
```

### Pre-commit Checks

1. **Build completes**: `make arch-x64-7.2` succeeds
2. **Digests valid**: Source checksums match
3. **Patches apply cleanly**: No fuzz or offset warnings
4. **PLIST accurate**: If present, matches installed files

### CI/CD Pipeline

GitHub Actions automatically builds packages when:
- Files change in `spk/`, `cross/`, `python/`, or `native/`
- Pull requests are opened or updated
- Pushes to any branch

The CI builds **all supported architectures** (same as `make all-supported`), including ARMv5, qoriq, comcerto2k-7.1, evansport, and hi3535/ARMv7L.

**Dependency analysis**: The CI analyzes changed files to determine which SPKs are affected and need rebuilding. This means:
- Updating a widely-used dependency (zlib, bzip2, openssl) will trigger builds for many packages
- Such updates may exceed CI time limits and should be isolated in their own PR
- Submit dependency updates in small batches to identify which ones affect too many packages

## Common Tasks

### Updating a Package Version

1. Update `PKG_VERS` in `cross/packagename/Makefile`
2. Download new source and regenerate digests: `make digests`
3. Check if patches still apply (update line numbers if needed)
4. Update `SPK_VERS` and increment `SPK_REV` in `spk/packagename/Makefile`
5. Update `CHANGELOG` with release notes
6. Test build: `make arch-x64-7.2`

### Major Version Upgrades

When upgrading major versions, consider:

1. **Dependency compatibility**: Check if dependencies need updating too (e.g., Erlang for ejabberd/RabbitMQ)
2. **Upgrade path**: Review upstream release notes for breaking changes between versions
3. **Database migrations**: Some apps may require database schema migrations
4. **Configuration changes**: Config file formats may change between major versions
5. **Feature flags**: Some software (e.g., RabbitMQ) requires enabling feature flags before upgrading

For packages with runtime dependencies (like Erlang-based apps), ensure version compatibility:
- Check minimum/maximum runtime version requirements in upstream docs
- Consider bundling related updates together (e.g., Erlang + RabbitMQ + ejabberd)
- Document upgrade warnings in `CHANGELOG` when migrations are needed

### Adding Architecture Support

Use `UNSUPPORTED_ARCHS` to exclude architectures:
```makefile
# Exclude old PPC architectures
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

# Exclude specific arch/version combinations
UNSUPPORTED_ARCHS_TCVERSION = armv7-6.2.4
```

### Adding Dependencies

```makefile
# Required dependencies (always built)
DEPENDS = cross/openssl cross/zlib

# Optional dependencies (conditionally included)
OPTIONAL_DEPENDS = cross/feature-lib

# Build-time only dependencies
BUILD_DEPENDS = native/cmake
```

### Service Setup Script

Common variables available in `service-setup.sh`:
- `SYNOPKG_PKGNAME` - Package name
- `SYNOPKG_PKGDEST` - Installation directory
- `SYNOPKG_PKGVAR` - Variable data directory (persists across upgrades)
- `SERVICE_COMMAND` - Command to start the service

```bash
# Example service-setup.sh
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/myapp --config ${SYNOPKG_PKGVAR}/config.ini"

service_postinst() {
    # Post-installation setup
    mkdir -p "${SYNOPKG_PKGVAR}/data"
}
```

## Troubleshooting

### Build Fails with Missing Dependencies

```bash
# Check dependency tree
cd spk/packagename
make dependency-tree

# Build dependencies first
cd cross/dependency
make arch-x64-7.2
```

### Patch Fails to Apply

Common causes:
- Wrong context lines (update patch with current source)
- Line number offsets (regenerate patch)
- Malformed patch (check for trailing whitespace, missing newlines)

```bash
# Test patch application manually
cd cross/packagename/work-x64-7.2/packagename-1.2.3
patch -p0 --dry-run < ../../patches/001-fix.patch
```

### PLIST Regeneration

For packages with many dependencies (e.g., ejabberd, Erlang-based), the PLIST file may need
regeneration when updating to new versions. Library versions change between releases.

```bash
# After a successful build, capture installed files
cd cross/packagename
make arch-x64-7.2

# Generate new PLIST from actual build output
cd work-x64-7.2/install/usr/local/packagename
find . -type f | sed 's|^\./||' | sort > ../../../../PLIST.new

# Compare with existing PLIST and update as needed
diff PLIST PLIST.new
```

> **Tip:** Consider using `PLIST.auto` which auto-generates a PLIST at build-time. This can serve as a starting point for creating the final PLIST.

### Toolchain Compiler Differences

Toolchain versions are defined in `toolchain/syno-<arch>-<version>/Makefile`. Rule of thumb:
- **DSM 7.2**: GCC 8.5
- **DSM 7.1**: GCC 7.x (except comcerto2k which uses older GCC)
- **DSM 6.2.4**: GCC 4.9.x (except ARMv5/88f6281 which uses GCC 4.6.4)

Common issues with older toolchains:
- Template deduction failures (e.g., `std::plus()` must be `std::plus<>()` for GCC 8.5)
- C++17/20 features may not be available
- Missing headers (e.g., `LLONG_MIN`/`LLONG_MAX` on old PPC toolchains)
- Atomic support varies by architecture (some require libatomic linking)
- ARMv5 (GCC 4.6.4) does not support `-std=c11` - use `-std=gnu99` instead

Use arch-specific patches for toolchain-specific fixes:
```
patches/
├── 001-general-fix.patch       # Applies to all architectures
└── ppc853x/                     # Only applies to ppc853x builds
    └── 001-fix-llong-min.patch
```

### Toolchain Not Found

```bash
# Download toolchain
cd toolchain/syno-x64-7.2
make
```

### Finding Package Files

```bash
# Search for packages
ls cross/*/Makefile | xargs grep -l "PKG_NAME = openssl"

# Find SPKs using a dependency
grep -r "cross/openssl" spk/*/Makefile
```

## References

- [SynoCommunity Wiki](https://github.com/SynoCommunity/spksrc/wiki)
- [Developers HOW-TO](https://github.com/SynoCommunity/spksrc/wiki/Developers-HOW-TO)
- [Using Python Wheels](https://github.com/SynoCommunity/spksrc/wiki/Using-wheels-to-distribute-Python-packages)
- [Architecture Reference](https://github.com/SynoCommunity/spksrc/wiki/Architecture-per-Synology-model)
- [FAQ](https://github.com/SynoCommunity/spksrc/wiki/Frequently-Asked-Questions)
