PKG_NAME = zlib
PKG_VERS = 1.2.11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://zlib.net
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://zlib.net/
COMMENT  = A Massively Spiffy Yet Delicately Unobtrusive Compression Library.
LICENSE  = zlib-license

CONFIGURE_ARGS = --shared --prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
