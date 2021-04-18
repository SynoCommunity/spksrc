PKG_NAME = irssi
PKG_VERS = 1.2.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/irssi-import/$(PKG_NAME)/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses cross/openssl
OPTIONAL_DEPENDS = cross/glib cross/glib-2.58

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# old compilers do not support current cross/glib (with meson build)
DEPENDS += cross/glib-2.58
else
DEPENDS += cross/glib
endif

HOMEPAGE = http://www.irssi.org/
COMMENT  = Irssi is a terminal based IRC client for UNIX systems. It also supports SILC and ICB protocols via plugins.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-ssl=openssl --with-curses=ncurses --without-perl

INSTALL_TARGET = install_irssi

include ../../mk/spksrc.cross-cc.mk

.PHONY: install_irssi
install_irssi:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
