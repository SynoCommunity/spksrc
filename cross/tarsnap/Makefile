PKG_NAME = tarsnap
PKG_VERS = 1.0.35
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-autoconf-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.tarsnap.com/download
PKG_DIR = $(PKG_NAME)-autoconf-$(PKG_VERS)

DEPENDS = cross/e2fsprogs cross/zlib cross/openssl

HOMEPAGE = https://www.tarsnap.com
COMMENT  = Online backups for the truly paranoid
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = 

include ../../mk/spksrc.cross-cc.mk
