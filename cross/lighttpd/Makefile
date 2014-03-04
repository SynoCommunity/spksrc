PKG_NAME = lighttpd
PKG_VERS = 1.4.33
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.lighttpd.net/lighttpd/releases-1.4.x
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/bzip2 cross/openssl cross/pcre cross/zlib

HOMEPAGE = http://www.lighttpd.net/
COMMENT  = A secure, fast, compliant and very flexible web-server
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-{bzip2,kerberos5,openssl,zlib}

include ../../mk/spksrc.cross-cc.mk
