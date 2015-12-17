PKG_NAME = xz
PKG_VERS = 5.2.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://tukaani.org/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = http://tukaani.org
COMMENT  = Free general-purpose data compression software with high compression ratio
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-scripts

include ../../mk/spksrc.cross-cc.mk
