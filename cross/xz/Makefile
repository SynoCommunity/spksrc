PKG_NAME = xz
PKG_VERS = 5.2.5
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://tukaani.org/xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://tukaani.org
COMMENT  = Free general-purpose data compression software with high compression ratio.
LICENSE  = various

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-scripts
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
