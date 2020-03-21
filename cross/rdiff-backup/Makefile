PKG_NAME = rdiff-backup
PKG_VERS = 2.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rdiff-backup/rdiff-backup/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/librsync cross/attr cross/acl

HOMEPAGE = http://www.nongnu.org/rdiff-backup/
COMMENT  = A remote incremental backup of all your files
LICENSE  = GNU GPL

include ../../mk/spksrc.python-wheel.mk
