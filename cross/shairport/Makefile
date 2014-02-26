PKG_NAME = shairport
PKG_VERS = 1.1.1
PKG_EXT = zip
PKG_DIST_NAME = 1.1.1.zip
PKG_DIST_SITE = https://github.com/abrasive/shairport/archive
PKG_DIR = $(PKG_NAME)-1.1.1

DEPENDS = cross/openssl cross/alsa-lib

HOMEPAGE = https://github.com/abrasive/shairport
COMMENT  = Use Synology NAS as an Airplay-Receiver. Requires USB-Soundcard or speakers.
LICENSE  =

GNU_CONFIGURE = 1

#ADDITIONAL_LDFLAGS = "-static"
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) PREFIX=$(STAGING_INSTALL_PREFIX) make install
