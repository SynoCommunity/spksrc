PKG_NAME = fish
PKG_VERS = 3.3.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/fish-shell/fish-shell/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/pcre2

HOMEPAGE = https://fishshell.com
COMMENT = fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.
LICENSE = Custom

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

include ../../mk/spksrc.cross-cmake.mk

CMAKE_ARGS += -DCURSES_NCURSES_LIBRARY=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib/libncursesw.so
CMAKE_ARGS += -DWITH_GETTEXT=OFF

# Fix compilation with newer compilers
# Flags to be added to CMake toolchain file
ifeq ($(call version_ge, ${TC_GCC}, 7.5),1)
ADDITIONAL_CXXFLAGS += -D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_C99_MATH
endif
