PKG_NAME = sshfs3
PKG_REAL_NAME = sshfs
PKG_VERS = 3.7.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libfuse/sshfs/releases/download/sshfs-$(PKG_VERS)
PKG_DIR = $(PKG_REAL_NAME)-$(PKG_VERS)

DEPENDS = cross/fuse3 cross/glib

# fuse3:
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/libfuse/sshfs
COMMENT  = sshfs is a network filesystem client to connect to SSH servers.
LICENSE  = GPLv2

include ../../mk/spksrc.cross-meson.mk
