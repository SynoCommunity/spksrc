PKG_NAME = fish
PKG_VERS = 4.0.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/fish-shell/fish-shell/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://fishshell.com
COMMENT = fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.
LICENSE = GPL-2.0

# requirements: C++11 compiler (g++ 4.8 or later, or clang 3.3 or later)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

# for fish_test_helper.c
ADDITIONAL_CFLAGS = -std=c11 -D_DEFAULT_SOURCE

include ../../mk/spksrc.cross-cmake.mk

CMAKE_ARGS += -DWITH_GETTEXT=OFF
