PKG_NAME = zstd
# warning: 1.4.4 and 1.4.5 fail for arch-aarch64
PKG_VERS = 1.4.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/facebook/zstd/releases/download/v${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/xz

HOMEPAGE = https://facebook.github.io/zstd/
COMMENT  = Zstandard is a fast compression algorithm, providing high compression ratios.
LICENSE  = GPLv2/BSD

CONFIGURE_TARGET = nop
COMPILE_TARGET = zstd_compile

include ../../mk/spksrc.cross-cc.mk

.PHONY: zstd_compile
zstd_compile:
	@$(RUN) $(MAKE) allmost
