PKG_NAME = fuse
PKG_VERS = 3.10.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/libfuse/archive/
PKG_DIR = libfuse-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/systemd cross/libiconv

HOMEPAGE = https://github.com/libfuse/libfuse
COMMENT  = The reference implementation of the Linux FUSE (Filesystem in Userspace) interface
LICENSE  = GPLv2, LGPLv2.1 (libfuse.so, libulockmgr.so)

#CONFIGURE_ARGS += -Dexamples=false -Duseroot=false -Dutils=false
CONFIGURE_ARGS += -Dexamples=false -Dutils=false

#ENV += MOUNT_FUSE_PATH=/$(INSTALL_PREFIX)/sbin

include ../../mk/spksrc.cross-meson.mk
