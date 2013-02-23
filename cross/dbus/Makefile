PKG_NAME = dbus
PKG_VERS = 1.6.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://dbus.freedesktop.org/releases/dbus
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/expat

HOMEPAGE = http://www.freedesktop.org/wiki/Software/dbus
COMMENT  = D-Bus is a message bus system, a simple way for applications to talk to one another
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-dnotify

INSTALL_TARGET = myInstall


include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
