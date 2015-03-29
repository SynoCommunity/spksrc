PKG_NAME = shairport
PKG_VERS = 1.1.1
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
# TODO switch to https://github.com/mikebrady/shairport-sync
PKG_DIST_SITE = https://github.com/abrasive/shairport
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/alsa-lib

HOMEPAGE = https://github.com/abrasive/shairport
COMMENT  = Use Synology NAS as an Airplay receiver. Requires USB soundcard or speakers.
LICENSE  =

GNU_CONFIGURE = 1

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) PREFIX=$(STAGING_INSTALL_PREFIX) make install
