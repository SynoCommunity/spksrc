PKG_NAME = cyrus-sasl
PKG_VERS = 2.1.28
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3

HOMEPAGE = https://github.com/cyrusimap/cyrus-sasl
COMMENT  = This is the Cyrus SASL API implementation. It can be used on the client or server side to provide authentication and authorization services. See RFC 4422 for more information.
LICENSE  = https://github.com/cyrusimap/cyrus-sasl/blob/master/COPYING

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
