PKG_NAME = squid
PKG_VERS = 3.1.20
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.squid-cache.org/Versions/v3/3.1/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.squid-cache.org/
COMMENT  = Squid is a fully-featured HTTP/1.0 proxy which is almost HTTP/1.1 compliant.
LICENSE  = 

GNU_CONFIGURE = 1

#DESTDIR = $(STAGING_INSTALL_PREFIX)

CONFIGURE_ARGS  = --prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

