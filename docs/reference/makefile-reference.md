# Makefile Reference

This is a comprehensive reference for all Makefile variables and targets in spksrc. For a tutorial-oriented guide, see [Developer Guide: Makefile Variables](../developer-guide/packaging/makefile-variables.md).

## Package Identification Variables

### Cross Package Variables (`cross/`)

| Variable | Required | Description | Example |
|----------|----------|-------------|--------|
| `PKG_NAME` | Yes | Package identifier (lowercase, hyphens) | `curl` |
| `PKG_VERS` | Yes | Upstream version | `8.4.0` |
| `PKG_EXT` | Yes | Archive extension | `tar.gz`, `tar.xz`, `zip` |
| `PKG_DIST_NAME` | Yes | Archive filename | `$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)` |
| `PKG_DIST_SITE` | Yes | Download URL base | `https://example.com/releases` |
| `PKG_DIST_FILE` | No | Local filename (if different) | `curl-source.tar.gz` |
| `PKG_DIR` | Yes | Directory after extraction | `$(PKG_NAME)-$(PKG_VERS)` |

### SPK Package Variables (`spk/`)

| Variable | Required | Description | Example |
|----------|----------|-------------|--------|
| `SPK_NAME` | Yes | Package name in Package Center | `transmission` |
| `SPK_VERS` | Yes | Version shown to users | `4.0.5` |
| `SPK_REV` | Yes | Revision (increment each release) | `25` |
| `SPK_ICON` | No | Icon file path (256x256+ PNG) | `src/transmission.png` |

## Metadata Variables

| Variable | Scope | Required | Description |
|----------|-------|----------|-------------|
| `HOMEPAGE` | Both | No | Project website URL |
| `COMMENT` | Both | Yes | Short description (one line) |
| `LICENSE` | Both | Yes | License identifier (GPLv2, MIT, Apache-2.0) |
| `LICENSE_FILE` | SPK | No | Path to license text file |
| `MAINTAINER` | SPK | Yes | Package maintainer name |
| `MAINTAINER_URL` | SPK | No | Maintainer URL (default: GitHub profile) |
| `DESCRIPTION` | SPK | Yes | Full description for Package Center |
| `DISPLAY_NAME` | SPK | Yes | Display name in Package Center |
| `CHANGELOG` | SPK | No | Changes in this version |
| `HELPURL` | SPK | No | Help/documentation URL |
| `SUPPORTURL` | SPK | No | Support URL |
| `BETA` | SPK | No | Set to 1 for beta packages |

## Dependency Variables

| Variable | Description | Example |
|----------|-------------|--------|
| `DEPENDS` | Cross packages to build and include | `cross/curl cross/openssl` |
| `BUILD_DEPENDS` | Packages needed only during build | `native/cmake` |
| `NATIVE_DEPENDS` | Native tools for build host | `native/ninja` |
| `SPK_DEPENDS` | SPK packages required at runtime | `"WebStation>=3.0"` |
| `SPK_CONFLICT` | Conflicting packages | `"transmission"` |

## Build System Variables

### Autotools (GNU Configure)

| Variable | Default | Description |
|----------|---------|-------------|
| `GNU_CONFIGURE` | 0 | Set to 1 to use autoconf |
| `CONFIGURE_ARGS` | | Arguments for configure script |
| `PRE_CONFIGURE_TARGET` | | Target to run before configure |
| `POST_CONFIGURE_TARGET` | | Target to run after configure |

### CMake

| Variable | Default | Description |
|----------|---------|-------------|
| `CMAKE_USE_TOOLCHAIN_FILE` | 1 | Use generated toolchain file |
| `CMAKE_ARGS` | | Additional CMake arguments |
| `CMAKE_BUILD_TYPE` | Release | Build type |

### Meson

| Variable | Default | Description |
|----------|---------|-------------|
| `MESON_USE_CROSS_FILE` | 1 | Use generated cross file |
| `MESON_ARGS` | | Additional Meson arguments |
| `MESON_BUILD_TYPE` | release | Build type |

### Compilation

| Variable | Description |
|----------|-------------|
| `ADDITIONAL_CFLAGS` | Extra C compiler flags |
| `ADDITIONAL_CXXFLAGS` | Extra C++ compiler flags |
| `ADDITIONAL_CPPFLAGS` | Extra preprocessor flags |
| `ADDITIONAL_LDFLAGS` | Extra linker flags |
| `COMPILE_TARGET` | Override default compile target |
| `PRE_COMPILE_TARGET` | Target to run before compile |
| `POST_COMPILE_TARGET` | Target to run after compile |
| `DISABLE_PARALLEL_MAKE` | Set to 1 to disable parallel build |

### Installation

| Variable | Description |
|----------|-------------|
| `INSTALL_TARGET` | Override install target (default: `install`) |
| `INSTALL_MAKE_OPTIONS` | Options passed to make install |
| `PRE_INSTALL_TARGET` | Target to run before install |
| `POST_INSTALL_TARGET` | Target to run after install |

## Service Configuration Variables

These variables apply to `spk/` packages with services.

| Variable | Description | Example |
|----------|-------------|--------|
| `SERVICE_SETUP` | Service setup script | `src/service-setup.sh` |
| `SERVICE_USER` | Service account name | `sc-transmission` |
| `SERVICE_WIZARD_SHARENAME` | Wizard variable for share path | `wizard_data_share` |
| `SSS_SCRIPT` | Custom start-stop-status script | `src/sss.sh` |
| `STARTABLE` | Whether package can be started | `yes` (default), `no` |
| `FWPORTS` | Firewall port definitions | `src/transmission.sc` |
| `SPK_COMMANDS` | Commands for usr-local-linker | `bin/transmission-daemon` |

## Web Interface Variables

These variables configure DSM main menu shortcuts for packages with web interfaces.

### Basic Variables

| Variable | Default | Description | Example |
|----------|---------|-------------|--------|
| `DSM_UI_DIR` | `app` | Directory for DSM UI config files | `app` |
| `SERVICE_PORT` | | Port for web interface (enables auto-generation) | `8096` |
| `SERVICE_PORT_TITLE` | `$(SPK_NAME)` | Firewall port display name | `Jellyfin (HTTP)` |
| `ADMIN_PORT` | | Port shown in Package Center admin link | `$(SERVICE_PORT)` |
| `ADMIN_URL` | `/` | URL path for admin link | `/admin` |
| `ADMIN_PROTOCOL` | `http` | Protocol for admin link | `https` |

### Advanced Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NO_SERVICE_SHORTCUT` | | Set to disable automatic shortcut generation |
| `DSM_UI_CONFIG` | | Path to custom `app/config` file (overrides auto-generation) |
| `SERVICE_URL` | `/` | URL path for web shortcut |
| `SERVICE_PORT_PROTOCOL` | `http` | Protocol for web shortcut |
| `SERVICE_PORT_ALL_USERS` | `true` | Allow all users access to shortcut |
| `SERVICE_TYPE` | `url` | Shortcut type |
| `SERVICE_DESC` | `$(DESCRIPTION)` | Tooltip description for shortcut |
| `DSM_APP_NAME` | `com.synocommunity.packages.$(SPK_NAME)` | Application identifier |
| `DSM_APP_PAGE` | | DSM 7+ application page |
| `DSM_APP_LAUNCH_NAME` | | DSM 7+ launch name |

### Service Control Variables

Used in `service-setup.sh`:

| Variable | Description | Example |
|----------|-------------|--------|
| `SERVICE_COMMAND` | Main executable to run | `$SYNOPKG_PKGDEST/bin/myapp` |
| `SVC_CWD` | Working directory for service | `$SYNOPKG_PKGVAR` |
| `SVC_BACKGROUND` | Run in background | `y` |
| `SVC_WRITE_PID` | Write PID file automatically | `y` |

## Path Variables (Read-Only)

These are set by the framework and available in Makefiles:

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `BASEDIR` | Repository root | `/spksrc/` |
| `WORK_DIR` | Build working directory | `work-x64-7.2/` |
| `INSTALL_DIR` | Installation staging area | `work-x64-7.2/install/` |
| `INSTALL_PREFIX` | Target install prefix | `/var/packages/myapp/target` |
| `STAGING_INSTALL_PREFIX` | Full staging path | `work-x64-7.2/install/var/packages/myapp/target` |
| `DISTRIB_DIR` | Downloaded archives | `distrib/` |
| `PACKAGES_DIR` | Built SPK output | `packages/` |

## Toolchain Variables (Read-Only)

Available after toolchain is loaded:

| Variable | Description |
|----------|-------------|
| `TC` | Toolchain identifier (syno-x64-7.2) |
| `TC_PATH` | Path to toolchain binaries |
| `TC_PREFIX` | Cross-compiler prefix |
| `TC_TARGET` | Target triplet (x86_64-pc-linux-gnu) |
| `TC_SYSROOT` | Toolchain sysroot path |
| `CC` | C compiler path |
| `CXX` | C++ compiler path |
| `LD` | Linker path |
| `AR` | Archiver path |
| `STRIP` | Strip utility path |
| `RANLIB` | Ranlib utility path |

## Architecture Variables

| Variable | Description |
|----------|-------------|
| `ARCH` | Target architecture (x64, aarch64, armv7) |
| `TCVERSION` | DSM version (7.2, 7.1, 6.2.4) |
| `TC_ARCH` | Architecture list for generic archs |
| `GENERIC_ARCHS` | List of generic architecture names |
| `x64_ARCHS` | Intel 64-bit architecture names |
| `ARMv7_ARCHS` | ARM 32-bit architecture names |
| `ARMv8_ARCHS` | ARM 64-bit architecture names |
| `UNSUPPORTED_ARCHS` | Architectures to exclude |

## Make Targets

### Cross Package Targets

| Target | Description |
|--------|-------------|
| `all` | Build everything (default) |
| `download` | Download source archive |
| `checksum` | Verify archive checksum |
| `extract` | Extract source archive |
| `patch` | Apply patches |
| `configure` | Run configure |
| `compile` | Compile sources |
| `install` | Install to staging |
| `plist` | Generate package list |
| `clean` | Remove work directory |

### SPK Package Targets

| Target | Description |
|--------|-------------|
| `all` | Build SPK package (default) |
| `depend` | Build dependencies |
| `copy` | Copy dependencies to staging |
| `strip` | Strip debug symbols |
| `cat` | Generate INFO, icons, scripts |
| `spk` | Create final .spk file |
| `clean` | Remove work directory |

### Architecture-Specific Targets

| Target Pattern | Description |
|----------------|-------------|
| `arch-<arch>-<tcversion>` | Build for specific architecture |
| `all-supported` | Build for all architectures in DEFAULT_TC |
| `publish-<arch>-<tcversion>` | Build and publish |

Examples:
```bash
make arch-x64-7.2
make arch-aarch64-7.1
make all-supported
```

### Python/Wheel Targets

| Target | Description |
|--------|-------------|
| `crossenv` | Create cross-compilation virtualenv |
| `crossenvclean` | Remove crossenv |
| `wheel-<arch>-<tcversion>` | Build wheels for architecture |

## Environment Variables

### Build Environment

| Variable | Description |
|----------|-------------|
| `PARALLEL_MAKE` | Parallel build mode (nop, max, N) |
| `NCPUS` | Number of CPUs for parallel builds |
| `V` | Verbose output when set to 1 |

### Proxy Configuration

| Variable | Description |
|----------|-------------|
| `http_proxy` | HTTP proxy URL |
| `https_proxy` | HTTPS proxy URL |
| `no_proxy` | Hosts to bypass proxy |

## local.mk Configuration

Optional `local.mk` in repository root for local settings:

```makefile
# Default toolchains to build
DEFAULT_TC = 7.1 6.2.4

# Parallel build configuration
PARALLEL_MAKE = max

# Proxy settings
WGET_ARGS = -e use_proxy=yes -e http_proxy=http://proxy:3128
```

## See Also

- [Developer Guide: Makefile Variables](../developer-guide/packaging/makefile-variables.md) - Tutorial guide
- [Developer Guide: Build Rules](../developer-guide/packaging/build-rules.md) - Build system includes
- [Framework: Makefile System](../framework/makefile-system.md) - Internal mk/*.mk details
