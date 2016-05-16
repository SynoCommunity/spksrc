PKG_NAME = sshfs
PKG_VERS = 2.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-fuse-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/sshfs/releases/download/sshfs_$(subst .,_,$(PKG_VERS))
PKG_DIR = $(PKG_NAME)-fuse-$(PKG_VERS)

DEPENDS = cross/fuse cross/glib

HOMEPAGE = https://github.com/libfuse/sshfs
COMMENT  = sshfs is a network filesystem client to connect to SSH servers
LICENSE  = GNU GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

