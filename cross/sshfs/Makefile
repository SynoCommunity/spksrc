PKG_NAME = sshfs
PKG_VERS = 2.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/sshfs/releases/download/sshfs-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fuse cross/glib

HOMEPAGE = https://github.com/libfuse/sshfs
COMMENT  = sshfs is a network filesystem client to connect to SSH servers
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

