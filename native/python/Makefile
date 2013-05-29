PKG_NAME = python
PKG_VERS = 2.7.5
PKG_EXT = tar.bz2
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS =

HOMEPAGE   = http://www.python.org/
COMMENT    = Python Programming Language
LICENSE    =

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
CONFIGURE_ARGS = --enable-unicode=ucs4 --enable-ipv6

include ../../mk/spksrc.native-cc.mk
