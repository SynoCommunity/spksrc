PKG_NAME = screen
PKG_VERS = 5.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/screen
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/linux-pam

# screen 5 is built with -std=c17, which gcc only accepts from 8:
#   cc1: error: unrecognized command line option '-std=c17'
MIN_GCC_VERSION = 8

HOMEPAGE = https://www.gnu.org/software/screen/
COMMENT  = Screen is a full-screen window manager that multiplexes a physical terminal between several processes, typically interactive shells.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

INSTALL_TARGET = screen_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: screen_install
screen_install:
	@$(MSG) "- Manually install screen (make install fails due to filesystem permissions)"
	@$(RUN) install -c screen $(STAGING_INSTALL_PREFIX)/bin/$(PKG_NAME)
