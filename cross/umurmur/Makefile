PKG_NAME = umurmur
PKG_VERS = 0.2.15
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/fatbob313/umurmur/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libconfig cross/protobuf-c cross/openssl

HOMEPAGE = https://github.com/fatbob313/umurmur
COMMENT  = Minimalistic Murmur (Mumble server)
LICENSE  =
PRE_CONFIGURE_TARGET = myPreConfigure

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-ssl=openssl

include ../../mk/spksrc.cross-cc.mk


.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) ./autogen.sh

