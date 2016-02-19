PKG_NAME = avahi
PKG_VERS = 0.6.31
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://avahi.org/download

DEPENDS = cross/glib cross/dbus cross/gdbm cross/libdaemon #cross/gobject

HOMEPAGE = http://avahi.org
COMMENT  = Package to facilitates service discovery on a local network
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --sysconfdir=$(INSTALL_PREFIX)/etc --localstatedir=$(INSTALL_PREFIX)/var
CONFIGURE_ARGS += --disable-static --enable-shared --disable-mono --disable-monodoc --disable-python --disable-qt3
CONFIGURE_ARGS += --disable-qt4 --enable-core-docs --with-distro=none --with-systemdsystemunitdir=no
CONFIGURE_ARGS += --disable-gtk --disable-gtk3 --disable-gobject

PATCH_TARGET = patch_target myPatch
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPatch
myPatch:
	$(RUN) sed -i 's/\(CFLAGS=.*\)-Werror \(.*\)/\1\2/' configure
	$(RUN) sed -e 's/-DG_DISABLE_DEPRECATED=1//' -e '/-DGDK_DISABLE_DEPRECATED/d' -i avahi-ui/Makefile.in

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) DESTDIR=$(INSTALL_DIR) install

