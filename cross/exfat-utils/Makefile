PKG_NAME = exfat-utils
PKG_VERS = 1.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/relan/exfat/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fuse

HOMEPAGE = https://github.com/relan/exfat 
COMMENT  = Free exFAT file system implementation  
LICENSE  = GNU GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
