PKG_NAME = neon
PKG_VERS = 0.29.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.webdav.org/neon
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/zlib cross/openssl

HOMEPAGE = http://www.webdav.org/neon/
COMMENT  = Neon is an HTTP and WebDAV client library, with a C interface
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS  =  --enable-shared --with-libxml2 --with-ssl=openssl --with-zlib
CONFIGURE_ARGS += XML2_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/xml2-config

include ../../mk/spksrc.cross-cc.mk

