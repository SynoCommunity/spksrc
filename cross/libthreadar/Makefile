PKG_NAME = libthreadar
PKG_VERS = 1.6.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/libthreadar/files/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Needs gcc >= 4.8: C++11 required (proven: 4.7.3 fails).
MIN_GCC_VERSION = 4.8
# other compiler problem (declaration of libthreadar::exception_base ...)
UNSUPPORTED_ARCHS = $(ARMv7L_ARCHS)

HOMEPAGE = http://libthreadar.sourceforge.net/
COMMENT  = Libthreadar is a C++ library providing a small set of C++ classes to manipulate threads in a very simple and efficient way from your C++ code.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
