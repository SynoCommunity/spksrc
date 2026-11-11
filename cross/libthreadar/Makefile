PKG_NAME = libthreadar
PKG_VERS = 1.6.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/libthreadar/files/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# C++11 as gcc 4.9 has it: 4.8.3 rejects exception_base's defaulted move assignment
# ("defaulted on its first declaration"), 4.7.3 C++11 altogether.
MIN_GCC_VERSION = 4.9

HOMEPAGE = http://libthreadar.sourceforge.net/
COMMENT  = Libthreadar is a C++ library providing a small set of C++ classes to manipulate threads in a very simple and efficient way from your C++ code.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
