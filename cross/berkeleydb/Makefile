PKG_NAME = db
PKG_VERS = 6.2.32
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
POST_CONFIGURE_TARGET = db_post_configure
CONFIGURE_ARGS  = $(TC_CONFIGURE_ARGS)
CONFIGURE_ARGS += --prefix=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-compat185
CONFIGURE_ARGS += --enable-cxx
CONFIGURE_ARGS += --enable-dbm
CONFIGURE_ARGS += --disable-static

include ../../mk/spksrc.cross-cc.mk

.PHONY: db_configure
db_configure: 
	@$(RUN) dist/configure $(CONFIGURE_ARGS)

# Fix with GCC_DEBUG_INFO whereas additional spaces makes the build to fail
.PHONY: db_post_configure
db_post_configure:
	@$(RUN) sed -i 's/-L /-L/g' Makefile
	@$(RUN) sed -i 's/-I /-I/g' Makefile
