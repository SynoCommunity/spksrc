PKG_NAME = fish
PKG_VERS = 4.0.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/fish-shell/fish-shell/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# requirements: C++11 compiler (g++ 4.8 or later, or clang 3.3 or later)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
# build with custom qoriq rust_target fails to build in spk folder (but not in cross/fish)
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

HOMEPAGE = https://fishshell.com
COMMENT = fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.
LICENSE = GPL-2.0

POST_INSTALL_TARGET = fish_post_install

ENV += FISH_BUILD_DOCS=0

# for fish_test_helper.c
ADDITIONAL_CFLAGS = -D_DEFAULT_SOURCE

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, $(TC_GCC), 5),1)
ADDITIONAL_CFLAGS += -std=c11
endif

# fish fails to build with gettext
CMAKE_ARGS = -DWITH_GETTEXT=OFF

# fish >= 4.0.0 requires rust
# IMPORTANT:
# fish must still be built with cmake
# direct builds with cargo/rust (using spksrc.cross-rust.mk) create
# experimental static versions without data files

# keep cross tools in ENV for cargo to find CC and LD of toolchain
CMAKE_USE_TOOLCHAIN_FILE = OFF

# define RUST_TARGET similar to spksrc.cross-rust-env.mk
# REMARKS: including spksrc.cross-rust-env.mk would break the build
ifeq ($(findstring $(ARCH), $(ARMv7_ARCHS)),$(ARCH))
RUST_TARGET = armv7-unknown-linux-gnueabihf
endif
ifeq ($(findstring $(ARCH), $(ARMv7L_ARCHS)),$(ARCH))
RUST_TARGET = armv7-unknown-linux-gnueabi
endif
ifeq ($(findstring $(ARCH), $(ARMv8_ARCHS)),$(ARCH))
RUST_TARGET = aarch64-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHS)),$(ARCH))
RUST_TARGET = powerpc-unknown-linux-gnuspe
endif
ifeq ($(findstring $(ARCH), $(x64_ARCHS)),$(ARCH))
RUST_TARGET = x86_64-unknown-linux-gnu
endif
ifeq ($(findstring $(ARCH), $(i686_ARCHS)),$(ARCH))
RUST_TARGET = i686-unknown-linux-gnu
endif

# CMake Warning at cmake/FindRust.cmake:719 (message):
#   CMake is in cross-compiling mode, but the cargo target-triple could not be
#   inferred.Falling back to the default host target.  Please consider manually
#   setting `Rust_CARGO_TARGET`.
CMAKE_ARGS += -DRust_CARGO_TARGET=$(RUST_TARGET)

include ../../mk/spksrc.cross-cmake.mk

.PHONY: fish_post_install
fish_post_install:
	@$(MSG) "Install license.rst (referenced in LICENSE file in package)"
	@install -d $(STAGING_INSTALL_PREFIX)/doc_src
	@install --m 755 $(WORK_DIR)/$(PKG_DIR)/doc_src/license.rst $(STAGING_INSTALL_PREFIX)/doc_src/
