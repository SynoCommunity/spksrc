PKG_NAME = augeas
PKG_VERS = 1.4.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = download.augeas.net
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/readline cross/libxml2

HOMEPAGE = http://augeas.net
COMMENT  = Augeas is a configuration editing tool.
LICENSE  = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

