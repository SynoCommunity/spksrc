PKG_NAME = avahi
PKG_VERS = 0.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/avahi/avahi/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/dbus

HOMEPAGE = https://www.avahi.org/
COMMENT  = Avahi mDNS/DNS-SD - headers-only package for compile-time linking (runtime uses DSM system avahi)
LICENSE  = LGPL

GNU_CONFIGURE = 1

# Minimal build for headers and client library only
# DSM has system avahi-daemon, we just need client libs
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --disable-glib
CONFIGURE_ARGS += --disable-gobject
CONFIGURE_ARGS += --disable-qt5
CONFIGURE_ARGS += --disable-gtk3
CONFIGURE_ARGS += --disable-mono
CONFIGURE_ARGS += --disable-python
CONFIGURE_ARGS += --disable-doxygen-doc
CONFIGURE_ARGS += --disable-manpages
CONFIGURE_ARGS += --disable-core-docs
CONFIGURE_ARGS += --disable-xmltoman
CONFIGURE_ARGS += --disable-compat-libdns_sd
CONFIGURE_ARGS += --disable-compat-howl
CONFIGURE_ARGS += --disable-introspection
CONFIGURE_ARGS += --disable-autoipd
CONFIGURE_ARGS += --disable-libevent
CONFIGURE_ARGS += --disable-stack-protector
CONFIGURE_ARGS += --with-distro=none
CONFIGURE_ARGS += --with-xml=expat
CONFIGURE_ARGS += --disable-gdbm

# We don't want daemon or utils, just the client library
CONFIGURE_ARGS += --disable-libdaemon

# Prevent automake regeneration by using no-op commands
ADDITIONAL_CFLAGS = -I$(WORK_DIR)/install/$(INSTALL_PREFIX)/include
ADDITIONAL_LDFLAGS = -L$(WORK_DIR)/install/$(INSTALL_PREFIX)/lib

# Override autotools regeneration commands to no-op
MAKE_ENV = ACLOCAL=true AUTOCONF=true AUTOMAKE=true AUTOHEADER=true

include ../../mk/spksrc.cross-cc.mk
