PKG_NAME = alsa-utils
PKG_VERS = 1.0.26
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.alsa-project.org/pub/utils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/alsa-lib cross/ncurses

HOMEPAGE = https://www.alsa-project.org/
COMMENT  = Advanced Linux Sound Architecture provides audio and MIDI functionality to the Linux operating system
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-curses=ncurses
CONFIGURE_TARGET = alsa-utils_configure
INSTALL_TARGET = alsa-utils_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: alsa-utils_configure
alsa-utils_configure:
	sed -i.orig $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/ncurses5-config \
	    -e 's#^prefix=".*"$$#prefix="$(INSTALL_DIR)/$(INSTALL_PREFIX)"#'
	$(RUN) PATH=$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/:$(PATH) ./configure $(REAL_CONFIGURE_ARGS)
	mv $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/ncurses5-config.orig $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/ncurses5-config

.PHONY: alsa-utils_install
alsa-utils_install:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

