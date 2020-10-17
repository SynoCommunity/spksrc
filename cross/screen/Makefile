PKG_NAME = screen
PKG_VERS = 4.8.0
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)

DEPENDS = cross/ncursesw

HOMEPAGE = https://www.gnu.org/software/screen/
COMMENT  = Screen is a full-screen window manager that multiplexes a physical terminal between several processes, typically interactive shells.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = screen_pre_configure
INSTALL_TARGET = screen_install

 
include ../../mk/spksrc.cross-cc.mk

.PHONY: screen_pre_configure
screen_pre_configure:
	$(RUN) autoconf

.PHONY: screen_install
screen_install:
	$(RUN) install -c screen $(STAGING_INSTALL_PREFIX)/bin/$(PKG_NAME)
