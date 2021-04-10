PKG_NAME = fish
PKG_VERS = 3.2.0
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

# Newer compiler/toolchain fix:
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_C99_MATH"

# Fix: CMake Error: The following variables are used in this project, but they are set to NOTFOUND.
# Please set them or make sure they are set and tested correctly in the CMake files:
# CURSES_EXTRA_LIBRARY (ADVANCED)
CMAKE_ARGS += -DCURSES_EXTRA_LIBRARY="" # magic string

# Fix: CMake Error at pcre2/CMakeLists.txt:314 (MESSAGE):
#  At least one of PCRE2_BUILD_PCRE2_8, PCRE2_BUILD_PCRE2_16 or
#  PCRE2_BUILD_PCRE2_32 must be enabled
CMAKE_ARGS += -DWCHAR_T_BITS=16 # magic value

# make spkclean && rm -rdf work-armv7-7.0/.fish-* && rm -rdf work-armv7-7.0/fish-3.2.0 && make arch-armv7-7.0
# make spkclean && rm -rdf work-x64-7.0/.fish-* && rm -rdf work-x64-7.0/fish-3.2.0 && make arch-x64-7.0
