PKG_NAME = postgresql
PKG_VERS = 10.11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.postgresql.org/pub/source/v10.11/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl cross/libxml2 cross/libxslt 
#cross/readline

HOMEPAGE = https://www.postgresql.org
COMMENT  = PostgreSQL is a powerful, open source object-relational database system with over 30 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance
LICENSE  = GPL Public License

CONFIGURE_ARGS = --with-template=linux CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" --without-readline

include ../../mk/spksrc.cross-cc.mk


