PKG_NAME = fontconfig
PKG_VERS = 2.13.91
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.freedesktop.org/software/fontconfig/release
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/freetype cross/util-linux

HOMEPAGE = http://www.freedesktop.org/wiki/Software/fontconfig/
COMMENT  = Fontconfig is a library for configuring and customizing font access.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-pic --disable-docs --with-arch=x86_64 --enable-iconv --enable-libxml2
CONFIGURE_ARGS += LIBXML2_CFLAGS="-I$(INSTALL_DIR)$(INSTALL_PREFIX)/include/libxml2"
CONFIGURE_ARGS += LIBXML2_LIBS="-L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -lxml2 -lz -liconv -lpthread -lm -ldl"

include ../../mk/spksrc.cross-cc.mk
