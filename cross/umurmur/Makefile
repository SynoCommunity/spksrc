PKG_NAME = umurmur
PKG_VERS = 0.2.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://umurmur.googlecode.com/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libconfig cross/protobuf-c cross/polarssl

HOMEPAGE = http://code.google.com/p/umurmur/
COMMENT  = Minimalistic Mumble server
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = 

include ../../mk/spksrc.cross-cc.mk

