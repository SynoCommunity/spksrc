PKG_NAME = sshfs
PKG_VERS = 2.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-fuse-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/fuse/files/$(PKG_NAME)-fuse/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-fuse-$(PKG_VERS)

DEPENDS = cross/fuse cross/glib

HOMEPAGE = http://fuse.sourceforge.net/sshfs.html
COMMENT  = sshfs is a filesystem client based on the SSH File Transfer Protocol.
LICENSE  = GNU GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

