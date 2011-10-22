

PKG_NAME = xzdec-static
PKG_VERS = 5.0.3
PKG_EXT = tar.xz
PKG_DIST_NAME = xz-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://tukaani.org/xz
PKG_DIR = xz-$(PKG_VERS)

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://tukaani.org/
COMMENT    = Free general-purpose data compression software with high compression ratio
LICENSE    =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-shared  --disable-xz \
                 --disable-lzmadec --disable-lzmainfo \
                 --disable-lzma-links --disable-scripts

include ../../mk/spksrc.cross-cc.mk
