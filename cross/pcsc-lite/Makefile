PKG_NAME = pcsc-lite
PKG_VERS = 1.8.26
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://pcsclite.apdu.fr/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://pcsclite.apdu.fr
COMMENT  = pcsc-lite
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_TARGET = myConfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) ./configure --disable-libsystemd --disable-libudev
