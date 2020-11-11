PKG_NAME = dar
PKG_VERS = 2.5.22
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/$(PKG_NAME)/files/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/bzip2 cross/libgcrypt cross/e2fsprogs cross/lzo cross/xz cross/libthreadar

HOMEPAGE = http://dar.linux.free.fr/
COMMENT = dar is a shell command that backs up from a single file to a whole filesystems, taking care of hard links, Extended Attributes, sparse files, etc.
LICENSE = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-mode=64

include ../../mk/spksrc.cross-cc.mk
