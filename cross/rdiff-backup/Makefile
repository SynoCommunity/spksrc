PKG_NAME = rdiff-backup
PKG_VERS = 1.2.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.savannah.gnu.org/releases/rdiff-backup/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/librsync

HOMEPAGE = http://www.nongnu.org/rdiff-backup/
COMMENT  = A remote incremental backup of all your files
LICENSE  = GNU GPL

include ../../mk/spksrc.python-wheel.mk
