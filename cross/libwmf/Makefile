PKG_NAME = libwmf
PKG_VERS = 0.2.8.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/wvware/files/libwmf/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/libpng cross/libjpeg cross/libxml2

HOMEPAGE = http://wvware.sourceforge.net/
COMMENT  = libwmf is a library for reading vector images in Microsoft's native Windows Metafile Format (WMF) and for either displaying them or converting them to more standard/open file formats.
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-freetype=$(STAGING_INSTALL_PREFIX)
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
