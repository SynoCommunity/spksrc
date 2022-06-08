PKG_NAME = avahi
PKG_VERS = 0.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lathiat/avahi/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib cross/libevent cross/libexpat cross/libdaemon cross/dbus

HOMEPAGE = https://www.avahi.org/
COMMENT  = Avahi - Service Discovery for Linux using mDNS/DNS-SD -- compatible with Bonjour
LICENSE  = LGPLv2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-distro=none 
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-qt5 --disable-qt4
CONFIGURE_ARGS += --disable-gtk --disable-gtk3
CONFIGURE_ARGS += --disable-gdbm
CONFIGURE_ARGS += --disable-python
CONFIGURE_ARGS += --disable-mono --disable-monodoc

# Build requires access to glib-mkenums Python script from cross/glib
ENV += PATH=$$PATH:$(STAGING_INSTALL_PREFIX)/bin

include ../../mk/spksrc.cross-cc.mk
