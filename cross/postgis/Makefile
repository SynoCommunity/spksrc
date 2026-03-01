PKG_NAME = postgis
PKG_VERS = 3.5.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.osgeo.org/postgis/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/postgresql cross/libgeos cross/libproj
BUILD_DEPENDS = native/postgresql

HOMEPAGE = https://postgis.net/
COMMENT = PostGIS is a spatial database extender for PostgreSQL
LICENSE = GPLv2

GNU_CONFIGURE = 1

# Cross-compilation requires a pg_config wrapper that returns cross-compiled
# paths for libraries but uses native PGXS for building
PG_VERSION = 17.4
PG_CONFIG_WRAPPER = $(WORK_DIR)/pg_config_wrapper
NATIVE_PG_DIR = $(realpath $(WORK_DIR)/../../../native/postgresql/work-native/install/usr/local)

CONFIGURE_ARGS  = --with-pgconfig=$(PG_CONFIG_WRAPPER)
CONFIGURE_ARGS += --with-geosconfig=$(STAGING_INSTALL_PREFIX)/bin/geos-config
CONFIGURE_ARGS += --with-projdir=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += PROJ_VERSION=8.2.1
CONFIGURE_ARGS += --without-raster
CONFIGURE_ARGS += --without-protobuf
CONFIGURE_ARGS += --without-gui
CONFIGURE_ARGS += --without-topology
# SSL libraries needed for libpq link check
CONFIGURE_ARGS += LIBS="-lssl -lcrypto -lpthread -lm"

# Disable parallel build (SQL file generation race conditions)
# Override CC since PGXS hardcodes gcc
COMPILE_MAKE_OPTIONS = -j1 CC="$(TC_PATH)$(TC_PREFIX)gcc"

PRE_CONFIGURE_TARGET = postgis_pre_configure
INSTALL_TARGET = postgis_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: postgis_pre_configure
postgis_pre_configure:
	@# Fix PostGIS configure to preserve LIBS during libpq check
	sed -i 's/LIBS="$$PGSQL_FE_LDFLAGS"/LIBS="$$PGSQL_FE_LDFLAGS $$LIBS"/g' $(WORK_DIR)/$(PKG_DIR)/configure
	@# Create pg_config wrapper from template
	sed -e 's|@NATIVE_PG_DIR@|$(NATIVE_PG_DIR)|g' \
	    -e 's|@PG_VERSION@|$(PG_VERSION)|g' \
	    -e 's|@CROSS_PG_INCLUDEDIR@|$(STAGING_INSTALL_PREFIX)/include|g' \
	    -e 's|@CROSS_PG_LIBDIR@|$(STAGING_INSTALL_PREFIX)/lib|g' \
	    -e 's|@CROSS_PG_SHAREDIR@|$(STAGING_INSTALL_PREFIX)/share|g' \
	    -e 's|@CROSS_PG_BINDIR@|$(STAGING_INSTALL_PREFIX)/bin|g' \
	    -e 's|@CROSS_CC@|$(TC_PATH)$(TC_PREFIX)gcc|g' \
	    $(CURDIR)/src/pg_config_wrapper.sh.in > $(PG_CONFIG_WRAPPER)
	chmod +x $(PG_CONFIG_WRAPPER)

.PHONY: postgis_install
postgis_install:
	$(RUN) $(MAKE) install DESTDIR=""
