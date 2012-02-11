
PKG_NAME = alsa-utils
PKG_VERS = 1.0.24.2
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.alsa-project.org/pub/utils

DEPENDS = cross/alsa-lib cross/ncurses

MAINTAINER = http://packages.nas-forum.com
HOMEPAGE   = http://www.alsa-project.org/
COMMENT    = Advanced Linux Sound Architecture provides audio and MIDI functionality to the Linux operating system
LICENSE    = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-curses=ncurses
CONFIGURE_TARGET = myConfigure
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	sed -i.orig $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/ncurses5-config \
	    -e 's#^prefix=".*"$$#prefix="$(INSTALL_DIR)/$(INSTALL_PREFIX)"#'
	$(RUN) PATH=$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/:$(PATH) ./configure $(REAL_CONFIGURE_ARGS)
	mv $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/ncurses5-config.orig $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/ncurses5-config

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

