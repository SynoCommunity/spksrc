PKG_NAME = fuse
PKG_VERS = 2.9.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/libfuse/archive/
PKG_DIR = libfuse-$(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/libfuse/libfuse
COMMENT  = The reference implementation of the Linux FUSE (Filesystem in Userspace) interface
LICENSE  = GPLv2, LGPLv2.1 (libfuse.so, libulockmgr.so)

GNU_CONFIGURE = 1
CONFIGURE_ARGS += enable_example=no
PRE_CONFIGURE_TARGET = fuse_pre_configure

ENV += MOUNT_FUSE_PATH=/$(INSTALL_PREFIX)/sbin

include ../../mk/spksrc.cross-cc.mk

.PHONY: fuse_pre_configure
fuse_pre_configure:
	$(RUN) ./makeconf.sh
