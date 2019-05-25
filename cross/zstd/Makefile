PKG_NAME = zstd
PKG_VERS = 1.4.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/facebook/zstd/releases/download/v${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.zstd.net
COMMENT  = Zstandard - Fast real-time compression algorithm
LICENSE  = GPLv2/BSD

#GNU_CONFIGURE = nop
CONFIGURE_TARGET = nop
#CONFIGURE_ARGS = HAVE_CXX=yes --disable-nls --enable-daemon --enable-utp

include ../../mk/spksrc.cross-cc.mk
