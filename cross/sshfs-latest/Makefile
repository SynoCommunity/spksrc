PKG_NAME = sshfs
PKG_VERS = 3.7.5
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/sshfs/releases/download/sshfs-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fuse3 cross/glib

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://github.com/libfuse/sshfs
COMMENT = sshfs is a network filesystem client to connect to SSH servers.
LICENSE = GPLv2

PRE_CONFIGURE_TARGET = sshfs_add_toolchain_file

include ../../mk/spksrc.cross-meson.mk

.PHONY: sshfs_add_toolchain_file
sshfs_add_toolchain_file:
	@$(MSG) Add header file lacking in some toolchains
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/include/linux
	@install -m 755 src/vm_sockets.h $(STAGING_INSTALL_PREFIX)/include/linux/
