PKG_NAME = postgis
PKG_VERS = 3.4.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.osgeo.org/postgis/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)


DEPENDS = cross/libproj cross/libgdal cross/libgeos cross/json-c cross/postgresql 

HOMEPAGE = https://postgis.net/

COMMENT = PROJ - PostGIS extends the capabilities of the PostgreSQL relational database by adding support for storing, indexing, and querying geospatial data
LICENSE = LGPL


# Use our own configure to define with-pgconfig
CONFIGURE_TARGET = postgis_configure

CONFIGURE_ARGS = --with-pgconfig=$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/pg_config

#GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cmake.mk

.PHONY: postgis_configure
postgis_configure:
	cd $(WORK_DIR)/$(PKG_DIR) && bash ./configure $(CONFIGURE_ARGS)
	
