PKG_NAME = rdiff-backup
PKG_VERS = 1.3.3
PKG_EXT = tar.gz
# TODO: this pattern will change with future builds
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.savannah.nongnu.org/releases/rdiff-backup
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/librsync cross/attr cross/acl

HOMEPAGE = http://www.nongnu.org/rdiff-backup/
COMMENT  = A remote incremental backup of all your files
LICENSE  = GNU GPL

include ../../mk/spksrc.python-wheel.mk
