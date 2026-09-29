PKG_NAME = fish
PKG_VERS = 4.9.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/fish-shell/fish-shell/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Rust edition2024 required
MIN_RUSTC_VERSION = 1.85

HOMEPAGE = https://fishshell.com
COMMENT = fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.
LICENSE = GPL-2.0

POST_INSTALL_TARGET = fish_post_install

ENV += FISH_BUILD_DOCS=0

include ../../mk/spksrc.common.mk

# fish fails to build with message localization (gettext)
CONFIGURE_ARGS = -DWITH_MESSAGE_LOCALIZATION=OFF

# fish >= 4.0.0 requires rust
# IMPORTANT:
# fish must still be built with cmake
# direct builds with cargo/rust (using spksrc.cross-rust.mk) create
# experimental static versions without data files
# The cargo target, linker and cc-rs compilers come from the framework
# (cmake toolchain file and rust tc_vars).

# pcre2-sys uses C99 features; older GCC (< 5.0) defaults to C89
ifeq ($(call version_lt, $(TC_GCC), 5),1)
ENV += TARGET_CFLAGS=-std=c99
endif

include ../../mk/spksrc.cross-cmake.mk

.PHONY: fish_post_install
fish_post_install:
	@$(MSG) "Install license.rst (referenced in LICENSE file in package)"
	@install -d $(STAGING_INSTALL_PREFIX)/doc_src
	@install --m 755 $(WORK_DIR)/$(PKG_DIR)/doc_src/license.rst $(STAGING_INSTALL_PREFIX)/doc_src/
