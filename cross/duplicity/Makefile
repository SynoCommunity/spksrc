PKG_NAME = duplicity
PKG_SHORT_VERS = 0.6
PKG_VERS = $(PKG_SHORT_VERS).22
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://launchpad.net/$(PKG_NAME)/$(PKG_SHORT_VERS)-series/$(PKG_VERS)/+download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/librsync

HOMEPAGE = http://duplicity.nongnu.org/
COMMENT  = Encrypted bandwidth-efficient backup using the rsync algorithm
LICENSE  =

include ../../mk/spksrc.python-module.mk
