PKG_NAME = python
PKG_VERS = 3.4.1
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS =

HOMEPAGE   = http://www.python.org/
COMMENT    = Python Programming Language
LICENSE    =

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
CONFIGURE_ARGS = --enable-ipv6 --without-ensurepip

COMPILE_TARGET = myCompile

include ../../mk/spksrc.native-cc.mk

.PHONY: myCompile
myCompile:
	@$(RUN) $(MAKE) Parser/pgen all
