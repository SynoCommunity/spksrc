PKG_NAME = libwmf
PKG_VERS = 0.2.17
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/caolanm/libwmf/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/libpng cross/libjpeg cross/libxml2

HOMEPAGE = https://github.com/caolanm/libwmf
COMMENT  = libwmf is a library for reading vector images in Microsoft's native Windows Metafile Format (WMF) and for either displaying them or converting them to more standard/open file formats.
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --with-freetype=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libxml2=$(STAGING_INSTALL_PREFIX)
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
