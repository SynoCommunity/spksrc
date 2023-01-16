PKG_NAME = openldap
PKG_VERS = 2.4.40
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.openldap.org
COMMENT  = OpenLDAP Software is an open source implementation of the Lightweight Directory Access Protocol
LICENSE  = open source

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-yielding_select=no --disable-slapd

include ../../mk/spksrc.cross-cc.mk
