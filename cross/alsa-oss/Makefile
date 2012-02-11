
PKG_NAME = alsa-oss
PKG_VERS = 1.0.17
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.alsa-project.org/pub/oss-lib

DEPENDS = cross/alsa-lib

MAINTAINER = http://packages.nas-forum.com
HOMEPAGE   = http://www.alsa-project.org/
COMMENT    = Advanced Linux Sound Architecture provides audio and MIDI functionality to the Linux operating system
LICENSE    = 

GNU_CONFIGURE = 1
INSTALL_TARGET = myInstall
 
include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)
