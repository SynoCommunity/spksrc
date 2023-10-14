PKG_NAME = eza
PKG_VERS = 0.13.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/eza-community/eza/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://eza.rocks/
COMMENT  = A modern replacement for 'ls'.
LICENSE  = MIT

include ../../mk/spksrc.cross-rust.mk
