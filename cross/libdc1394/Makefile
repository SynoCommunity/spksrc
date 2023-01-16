PKG_NAME = libdc1394
PKG_VERS = 2.2.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/libdc1394/libdc1394-2/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://damien.douxchamps.net/ieee1394/libdc1394/
COMMENT  = Libdc1394 is a library that provides a complete high level application programming interface (API) for developers who wish to control IEEE 1394 based cameras that conform to the 1394-based Digital Camera Specifications (also known as the IIDC or DCAM Specifications).
LICENSE  = GPL

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
