PKG_NAME = openssl
PKG_VERS = 0.9.8u
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.openssl.org/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://www.openssl.org/
COMMENT  = Compression Library
LICENSE  = zlib-license

CONFIGURE_TARGET = myConfigure

INSTALL_TARGET = myInstall

STAGING_INSTALL_PREFIX := $(INSTALL_DIR)

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) ./Configure --openssldir=$(INSTALL_PREFIX) linux-generic32 zlib-dynamic shared threads

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install_sw INSTALL_PREFIX=$(INSTALL_DIR)

