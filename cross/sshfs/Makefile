PKG_NAME = sshfs
PKG_VERS = 3.7.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/sshfs/archive/
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fuse3
# Already available through the toolkit:
# cross/glib

HOMEPAGE = https://github.com/libfuse/sshfs
COMMENT  = sshfs is a network filesystem client to connect to SSH servers.
LICENSE  = GPLv2

include ../../mk/spksrc.cross-meson.mk

# Force indlude path to toolkit dbus & glib
#ENV += "DBUS_CFLAGS=-I$(TOOLKIT_ROOT)/include/dbus-1.0 -I$(TOOLKIT_ROOT)/lib/dbus-1.0/include"
#ENV += "GLIB_CFLAGS=-I$(TOOLKIT_ROOT)/include/glib-2.0 -I$(TOOLKIT_ROOT)/lib/glib-2.0/include"
