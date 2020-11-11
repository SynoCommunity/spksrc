PKG_NAME = alsa-oss
PKG_VERS = 1.0.28
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.alsa-project.org/pub/oss-lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/alsa-lib

HOMEPAGE = https://www.alsa-project.org/
COMMENT  = Advanced Linux Sound Architecture provides audio and MIDI functionality to the Linux operating system
LICENSE  =

GNU_CONFIGURE = 1
INSTALL_TARGET = alsa-oss_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: alsa-oss_install
alsa-oss_install:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)
