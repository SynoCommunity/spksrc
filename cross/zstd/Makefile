PKG_NAME = zstd
PKG_VERS = 1.5.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/facebook/zstd/releases/download/v${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/xz cross/lz4

HOMEPAGE = https://facebook.github.io/zstd/
COMMENT  = Zstandard is a fast compression algorithm, providing high compression ratios.
LICENSE  = GPLv2/BSD

MESON_BUILD_DIR = build/meson
NINJA_BUILD_DIR = .

include ../../mk/spksrc.cross-meson.mk
