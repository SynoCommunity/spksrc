PKG_NAME = uriparser
PKG_VERS = 0.9.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/Sources/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = http://sourceforge.net/projects/uriparser
COMMENT  = Strictly RFC 3986 compliant URI parsing and handling library 
LICENSE  = New BSD license

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-test --disable-doc

include ../../mk/spksrc.cross-cc.mk
