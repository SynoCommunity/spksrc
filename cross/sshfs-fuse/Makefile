PKG_NAME = sshfs-fuse
PKG_VERS = 2.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/fuse/files/sshfs-fuse/2.5
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fuse cross/glib cross/zlib cross/libffi

HOMEPAGE = http://fuse.sourceforge.net/sshfs.html
COMMENT  = File System in User Space
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = 

include ../../mk/spksrc.cross-cc.mk