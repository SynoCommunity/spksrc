PKG_NAME = postgresql
PKG_VERS = 9.3.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.postgresql.org/pub/source/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/libxslt cross/openssl cross/readline

HOMEPAGE = http://www.postgresql.org
COMMENT  = PostgreSQL is a powerful, open source object-relational database system. 
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = XML2_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/xml2-config --with-libxslt --with-libxml --with-openssl --enable-thread-safety

include ../../mk/spksrc.cross-cc.mk