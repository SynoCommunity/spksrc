PKG_NAME = jpegoptim
PKG_VERS = 1.4.6
PKG_EXT = tar.gz
PKG_DIST_NAME = RELEASE.$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tjko/jpegoptim/archive
PKG_DIST_FILE=$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-RELEASE.$(PKG_VERS)

DEPENDS = cross/libjpeg

HOMEPAGE = https://github.com/tjko/jpegoptim
COMMENT = utility to optimize/compress JPEG files 
LICENSE = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
