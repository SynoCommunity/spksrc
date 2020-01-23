PKG_NAME = sshfs
PKG_VERS = 3.6.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/sshfs/releases/download/sshfs-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fuse cross/glib

HOMEPAGE = https://github.com/libfuse/sshfs
COMMENT  = sshfs is a network filesystem client to connect to SSH servers
LICENSE  = GPLv2

CONFIGURE_TARGET = sshfs_custom_configure
COMPILE_TARGET = sshfs_custom_compile
INSTALL_TARGET = sshfs_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: sshfs_custom_configure sshfs_custom_compile sshfs_custom_install

sshfs_custom_configure:
	$(RUN) mkdir -p build
	$(RUN) meson --prefix=$(INSTALL_PREFIX) . build

sshfs_custom_compile:
	$(RUN) ninja

sshfs_custom_install:
	$(RUN) ninja install
