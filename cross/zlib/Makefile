

PKG_NAME = zlib
PKG_VERS = 1.2.5
PKG_EXT = tar.gz
PKG_REV = 1
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://zlib.net
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

MAINTAINER=	superzebulon@superzebulon.org
HOMEPAGE=	http://zlib.net/
COMMENT=	Compression Library
LICENSE=	zlib-license

CONFIGURE_ARGS = --shared --prefix=$(INSTALL_PREFIX)

PC_FILES = zlib.pc

include ../../mk/spksrc.cross-cc.mk
