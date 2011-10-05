

PKG_NAME = curl
PKG_VERS = 7.22.0
PKG_EXT = tar.bz2
PKG_REV = 1
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://curl.haxx.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://curl.haxx.se/
COMMENT    = Compression Library
LICENSE    = 

GNU_CONFIGURE = 1


PC_FILES = libcurl.pc

include ../../mk/spksrc.cross-cc.mk
