PKG_NAME = umurmur
PKG_VERS = 0.2.16
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/umurmur/umurmur/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libconfig cross/protobuf-c cross/openssl

HOMEPAGE = https://github.com/umurmur/umurmur
COMMENT  = Minimalistic Murmur (Mumble server)
LICENSE  =

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

PRE_CONFIGURE_TARGET = myPreConfigure
CONFIGURE_ARGS = --with-ssl=openssl

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) ./autogen.sh

