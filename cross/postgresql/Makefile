PKG_NAME = postgresql
PKG_VERS = 13.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.postgresql.org/pub/source/v$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl cross/libxml2 cross/libxslt cross/readline

HOMEPAGE = https://www.postgresql.org
COMMENT  = PostgreSQL is a powerful, open source object-relational database system with over 30 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance

LICENSE  = PostgreSQL Licence

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-template=linux --with-openssl
CONFIGURE_ARGS += --with-system-tzdata=/usr/share/zoneinfo

# If you want to invoke the build from another makefile rather than manually,
# you must unset MAKELEVEL or set it to zero.
# see: INSTALL file
ENV += MAKELEVEL=

include ../../mk/spksrc.cross-cc.mk


