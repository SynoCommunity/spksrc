PKG_NAME = libigloo
PKG_VERS = 0.9.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.xiph.org/releases/igloo
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/rhash

HOMEPAGE = https://icecast.org/
COMMENT  = Generic C framework developed and used by the Icecast project.
LICENSE  = LGPLv2+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk
