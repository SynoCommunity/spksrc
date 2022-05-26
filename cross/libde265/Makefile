PKG_NAME = libde265
PKG_VERS = 1.0.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/strukturag/libde265/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = http://www.libheif.org
COMMENT  = Open h.265 video codec implementation. 
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
# Disable build of applications, build library only
CONFIGURE_ARGS = --disable-dec265 --disable-sherlock265

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
