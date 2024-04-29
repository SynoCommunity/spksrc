PKG_NAME = libpsl
PKG_VERS = 0.21.2
PKG_EXT = tar.lz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rockdaboot/libpsl/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libidn2

HOMEPAGE = https://github.com/rockdaboot/libpsl
COMMENT  = C library for the Public Suffix List.
LICENSE  = MIT

include ../../mk/spksrc.cross-meson.mk
