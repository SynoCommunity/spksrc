PKG_NAME = pgvector
PKG_VERS = 0.8.6
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/pgvector/pgvector/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/postgresql

MIN_GCC_VERSION = 5

HOMEPAGE = https://github.com/pgvector/pgvector
COMMENT  = Open-source vector similarity search for PostgreSQL.
LICENSE  = PostgreSQL

CONFIGURE_TARGET = nop
INSTALL_TARGET = pgvector_install

# We build a pg_config file that works with cross compilation
# - return the correct path for --pgxs
# - provide postgresql include dirs.
PG_CONFIG = $(WORK_DIR)/$(PKG_DIR)/pg_config

PRE_COMPILE_TARGET = $(PG_CONFIG)

# pgxs.mk, the extension makefile, is included in pgvector Makefile
# native pg_config --pgxs retuns:
# /spksrc/native/postgresql/work-native/install/usr/local/lib/pgxs/src/makefiles/pgxs.mk
# the correct path would be:
# /spksrc/native/postgresql/work-native/install/usr/local/lib/postgresql/pgxs/src/makefiles/pgxs.mk
# we use pgxs.mk created by cross/postgres (it is exact the same as the native was and we get rid of native/postgresql)
PG_PGXS_MK = $(shell find $(realpath $(STAGING_INSTALL_PREFIX)/) -type f -name pgxs.mk)

# directory of postgres.h is different when building
# in spk/postgresql and cross/postgis folders
ifneq ($(findstring $(PKG_NAME),$(INSTALL_PREFIX)),)
# building in cross/pgvector
PG_INCLUDE_DIR = $(STAGING_INSTALL_PREFIX)/include/postgresql
else
# building in spk/postgresql
PG_INCLUDE_DIR = $(STAGING_INSTALL_PREFIX)/include
endif

# Makefile of pgvector does not define PGXS, hence NO_PGXS=1
COMPILE_ARGS = NO_PGXS=1 \
	PG_CONFIG=$(PG_CONFIG) \
	PG_CFLAGS="-I$(PG_SERVER_INCLUDE_DIR) -I$(STAGING_INSTALL_PREFIX)/include" \
	CC="$(TC_PATH)$(TC_PREFIX)gcc" \
	OPTFLAGS=""

include ../../mk/spksrc.cross-cc.mk

$(PG_CONFIG):
	@$(MSG) - Create pg_config to return $(PG_PGXS_MK)
	@printf '#!/bin/sh\n' > $@
	@printf '# pg_config for pgvector cross-compilation\n' >> $@
	@printf '# Returns correct paths for building, especially for pgxs.mk\n' >> $@
	@printf 'case "$$1" in\n' >> $@
	@printf '  --pgxs) echo "$(PG_PGXS_MK)" ;;\n' >> $@
	@printf '  --includedir|--pkgincludedir) echo "$(PG_INCLUDE_DIR)" ;;\n' >> $@
	@printf '  --includedir-server) echo "$(PG_INCLUDE_DIR)/server" ;;\n' >> $@
	@printf '  --libdir|--pkglibdir) echo "$(INSTALL_PREFIX)/lib" ;;\n' >> $@
	@printf '  *) echo "pg_config-not-implemented$$1" ;;\n' >> $@
	@printf 'esac\n' >> $@
	@chmod +x $@

.PHONY: pgvector_install
pgvector_install:
	@$(MSG) "Installing pgvector extension files"
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib -d $(STAGING_INSTALL_PREFIX)/share/extension
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/vector.so $(STAGING_INSTALL_PREFIX)/lib/
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/vector.control $(STAGING_INSTALL_PREFIX)/share/extension/
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/sql/*.sql $(STAGING_INSTALL_PREFIX)/share/extension/
