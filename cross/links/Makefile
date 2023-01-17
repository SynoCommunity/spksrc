PKG_NAME = links
PKG_VERS = 2.12
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://links.twibright.com/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/bzip2 cross/libevent cross/openssl cross/xz cross/zlib

HOMEPAGE = http://links.twibright.com/
COMMENT  = Links is a web browser running in text mode.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-ssl=openssl

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
