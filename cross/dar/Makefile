PKG_NAME = dar
PKG_VERS = 2.5.15
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/$(PKG_NAME)/files/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
SRC_DIR= $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/

DEPENDS = cross/zlib cross/libgcrypt cross/libgpg-error

HOMEPAGE = http://dar.linux.free.fr/
COMMENT = "dar is a shell command that backs up from a single file to a whole filesystems, taking care of hard links, Extended Attributes, sparse files, MacOS's file forks, any inode type (including Solaris Door inodes), etc."
LICENSE = GNU GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-mode=64 --disable-dar-static --disable-static

include ../../mk/spksrc.cross-cc.mk
