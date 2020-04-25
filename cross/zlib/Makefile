PKG_NAME = zlib
PKG_VERS = 1.2.11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://zlib.net
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://zlib.net/
COMMENT  = Compression Library
LICENSE  = zlib-license

ifeq ($(strip $(PKG_LINK_TYPE)),static)
CONFIGURE_LINK_ARG = --static
else
CONFIGURE_LINK_ARG = --shared
endif


CONFIGURE_ARGS = --prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
