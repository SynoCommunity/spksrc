PKG_NAME = postgis
PKG_VERS = 3.6.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.osgeo.org/postgis/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/postgresql
DEPENDS += cross/libgeos
DEPENDS += cross/libproj
DEPENDS += cross/json-c

# libgeos and libproj:
MIN_GCC_VERSION = 8

HOMEPAGE = https://postgis.net/
COMMENT = PostGIS extends the capabilities of the PostgreSQL relational database by adding support for storing, indexing, and querying geospatial data.
LICENSE = GPLv2

GNU_CONFIGURE = 1

# We build a pg_config file that works with cross compilation
# - return the correct path for --pgxs
# - provide postgresql include dirs.
# - provide postresql version
PG_CONFIG = $(WORK_DIR)/$(PKG_DIR)/pg_config
PG_VERSION = 17.11

PRE_CONFIGURE_TARGET = $(PG_CONFIG)

# pgxs.mk, the extension makefile, is included in postgis Makefile
# native pg_config --pgxs retuns:
# /spksrc/native/postgresql/work-native/install/usr/local/lib/pgxs/src/makefiles/pgxs.mk
# the correct path would be:
# /spksrc/native/postgresql/work-native/install/usr/local/lib/postgresql/pgxs/src/makefiles/pgxs.mk
# we use pgxs.mk created by cross/postgres (it is exact the same as the native was and we get rid of native/postgresql)
PG_PGXS_MK = $(shell find $(realpath $(STAGING_INSTALL_PREFIX)/) -type f -name pgxs.mk)

# directory of postgres.h is different when building
# in spk/postgresql and cross/postgis folders
ifneq ($(findstring $(PKG_NAME),$(INSTALL_PREFIX)),)
# building in cross/postgis
PG_INCLUDE_DIR = $(STAGING_INSTALL_PREFIX)/include/postgresql
# The build of the modules does not use pg_config
# and therfore does not find postgres.h without this include directory:
ADDITIONAL_CFLAGS = -I$(PG_INCLUDE_DIR)/server
else
# building in spk/postgresql
PG_INCLUDE_DIR = $(STAGING_INSTALL_PREFIX)/include
endif

CONFIGURE_ARGS  = --with-pgconfig=$(PG_CONFIG)
CONFIGURE_ARGS += --with-geosconfig=$(STAGING_INSTALL_PREFIX)/bin/geos-config
CONFIGURE_ARGS += --with-xml2config=$(STAGING_INSTALL_PREFIX)/bin/xml2-config
CONFIGURE_ARGS += --without-raster
CONFIGURE_ARGS += --without-protobuf
CONFIGURE_ARGS += --without-gui
CONFIGURE_ARGS += --without-topology
CONFIGURE_ARGS += --disable-static

# Disable parallel build (SQL file generation race conditions)
# Override CC since PGXS hardcodes gcc
COMPILE_ARGS = -j1 CC="$(TC_PATH)$(TC_PREFIX)gcc"
POST_INSTALL_TARGET = postgis_post_install

include ../../mk/spksrc.cross-cc.mk

$(PG_CONFIG):
	@$(MSG) - Create pg_config to return $(PG_PGXS_MK)
	@printf '#!/bin/sh\n' > $@
	@printf '# pg_config for postgis cross-compilation\n' >> $@
	@printf '# Returns correct paths for building, especially for pgxs.mk\n' >> $@
	@printf 'case "$$1" in\n' >> $@
	@printf '  --pgxs) echo "$(PG_PGXS_MK)" ;;\n' >> $@
	@printf '  --version) echo "$(PG_VERSION)" ;;\n' >> $@
	@printf '  --includedir) echo "$(PG_INCLUDE_DIR)" ;;\n' >> $@
	@printf '  --includedir-server) echo "$(PG_INCLUDE_DIR)/server" ;;\n' >> $@
	@printf '  --pkgincludedir) echo "$(STAGING_INSTALL_PREFIX)/include" ;;\n' >> $@
	@printf '  --libdir|--pkglibdir) echo "$(INSTALL_PREFIX)/lib" ;;\n' >> $@
	@printf '  --bindir) echo "$(INSTALL_PREFIX)/bin" ;;\n' >> $@
	@printf '  --sharedir) echo "$(INSTALL_PREFIX)/share" ;;\n' >> $@
	@printf '  --docdir|--htmldir) echo "$(INSTALL_PREFIX)/share/doc" ;;\n' >> $@
	@printf '  --mandir) echo "$(INSTALL_PREFIX)/share/man" ;;\n' >> $@
	@printf '  --locale) echo "$(INSTALL_PREFIX)/share/locale" ;;\n' >> $@
	@printf '  --cc) echo "$(TC_PATH)$(TC_PREFIX)gcc" ;;\n' >> $@
	@printf '  --cflags) echo "$(CFLAGS)" ;;\n' >> $@
	@printf '  *) echo "pg_config-not-implemented$$1" ;;\n' >> $@
	@printf 'esac\n' >> $@
	@chmod +x $@

.PHONY: postgis_post_install
postgis_post_install:
	@# Ship the missing upgrade tag script so in-place 3.5.7 -> 3.6.4 upgrades work
	ln -sf postgis--TEMPLATED--TO--ANY.sql $(STAGING_INSTALL_PREFIX)/share/extension/postgis--3.5.7--ANY.sql
