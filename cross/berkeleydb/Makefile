PKG_NAME = db
PKG_VERS = 6.2.23
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.oracle.com/berkeley-db
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
SRC_DIR = build_unix

DEPENDS =

HOMEPAGE = https://www.oracle.com/technetwork/database/database-technologies/berkeleydb/downloads/index.html
COMMENT  = Berkeley DB is a family of embedded key-value database libraries providing scalable high-performance data management services to applications. The Berkeley DB products use simple function-call APIs for data access and management.
LICENSE  = AGPLv3

CONFIGURE_TARGET = db_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: db_configure
db_configure: 
	$(RUN) dist/configure $(TC_CONFIGURE_ARGS) --prefix=$(INSTALL_DIR)/$(INSTALL_PREFIX) --enable-dbm
