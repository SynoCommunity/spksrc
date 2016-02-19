PKG_NAME = alsa-utils
PKG_VERS = 1.1.0
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.alsa-project.org/pub/utils

DEPENDS = cross/ncurses cross/alsa-lib cross/libsamplerate cross/fftw

HOMEPAGE = http://www.alsa-project.org/
COMMENT  = Advanced Linux Sound Architecture provides audio and MIDI functionality to the Linux operating system
LICENSE  =

GNU_CONFIGURE = 1
include ../ncurses/which-ncurses.mk
CONFIGURE_ARGS = --with-curses=ncurses$(NCURSES_SUFFIX) --disable-xmlto --disable-bat
CONFIGURE_ARGS += --with-udev-rules-dir=$(INSTALL_PREFIX)/var/udev --with-asound-state-dir=$(INSTALL_PREFIX)/var/lib/alsa
CONFIGURE_TARGET = myConfigure
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	sed -i.orig $(STAGING_INSTALL_PREFIX)/bin/ncurses$(NCURSES_SUFFIX)6-config \
	    -e 's#^prefix=".*"$$#prefix="$(STAGING_INSTALL_PREFIX)"#'
	$(RUN) PATH=$(STAGING_INSTALL_PREFIX)/bin/:$(PATH) ./configure $(REAL_CONFIGURE_ARGS)
	mv $(STAGING_INSTALL_PREFIX)/bin/ncurses$(NCURSES_SUFFIX)6-config.orig $(STAGING_INSTALL_PREFIX)/bin/ncurses$(NCURSES_SUFFIX)6-config

.PHONY: myInstall
myInstall:
	$(RUN) make DESTDIR=$(INSTALL_DIR) install

