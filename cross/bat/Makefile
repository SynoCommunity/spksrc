PKG_NAME = bat
PKG_VERS = 0.22.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sharkdp/bat/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib-ng

# unsupported by cross/zlib-ng
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/sharkdp/bat
COMMENT  = A cat(1) clone with wings.
LICENSE  = MIT or Apache 2.0

include ../../mk/spksrc.cross-rust.mk
