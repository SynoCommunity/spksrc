PKG_NAME = popt
PKG_VERS = 1.14
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://rpm5.org/files/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libtool

HOMEPAGE = http://rpm5.org/
COMMENT  = Popt is a C library for parsing command line parameters.
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ac_cv_va_copy=C99

include ../../mk/spksrc.cross-cc.mk
