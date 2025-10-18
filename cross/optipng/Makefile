PKG_NAME = optipng
PKG_VERS = 7.9.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/optipng/files/OptiPNG/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng

HOMEPAGE = https://optipng.sourceforge.net/
COMMENT  = OptiPNG is a PNG optimizer that recompresses image files to a smaller size, without losing any information. This program also converts external formats (BMP, GIF, PNM and TIFF) to optimized PNG, and performs PNG integrity checks and corrections.
LICENSE  = zlib/libpng License

POST_INSTALL_TARGET = optipng_post_install

CMAKE_ARGS += -DOPTIPNG_USE_SYSTEM_LIBS=ON
CMAKE_ARGS += -DOPTIPNG_BUILD_TESTS=OFF

include ../../mk/spksrc.cross-cmake.mk

.PHONY: optipng_post_install
optipng_post_install:
	@chmod +x $(STAGING_INSTALL_PREFIX)/bin/optipng
