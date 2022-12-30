PKG_NAME = libidn2
PKG_VERS = 2.3.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/libidn
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libunistring

HOMEPAGE = https://www.gnu.org/software/libidn/#libidn2
COMMENT  = Libidn2 is a free software implementation of IDNA2008, Punycode and Unicode TR46. Its purpose is to encode and decode internationalized domain names.
LICENSE  = The installed C library libidn2 is dual-licensed under LGPLv3+|GPLv2+, while the rest of the package is GPLv3+

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-doc 
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
