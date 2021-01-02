PKG_NAME = zstd
# warning: 1.4.4 and 1.4.5 fail for arch-aarch64
PKG_VERS = 1.4.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/facebook/zstd/releases/download/v${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/xz

HOMEPAGE = https://facebook.github.io/zstd/
COMMENT  = Zstandard is a fast compression algorithm, providing high compression ratios.
LICENSE  = GPLv2/BSD

MESON_BUILD_DIR = build/meson
NINJA_BUILD_DIR = ./

include ../../mk/spksrc.cross-meson.mk
