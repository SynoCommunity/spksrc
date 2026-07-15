PKG_NAME = pgvector
PKG_VERS = 0.8.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/pgvector/pgvector/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/postgresql
BUILD_DEPENDS = native/postgresql

HOMEPAGE = https://github.com/pgvector/pgvector
COMMENT  = Open-source vector similarity search for PostgreSQL.
LICENSE  = PostgreSQL

CONFIGURE_TARGET = nop
INSTALL_TARGET = pgvector_install

# pgvector uses PGXS — needs native pg_config for build rules and cross
# pg_config for include/library paths.  We can't run the cross pg_config
# (it's a target binary), so compute paths from its filesystem location.
NATIVE_PG_DIR = $(realpath $(WORK_DIR)/../../../native/postgresql/work-native/install/usr/local)
PGSQL_CROSS = $(abspath $(CURDIR)/../postgresql/work-$(ARCH)-$(TCVERSION)/install/usr/local/postgresql)
PGSQL_SPK   = $(STAGING_INSTALL_PREFIX)

# Find cross pg_config — standalone build → cross path, spk build → spk path
PG_CONFIG    = $(or $(wildcard $(PGSQL_CROSS)/bin/pg_config),$(wildcard $(PGSQL_SPK)/bin/pg_config))
PGSQL_INC    = $(dir $(PG_CONFIG))../include

# Pass cross include paths via PG_CPPFLAGS (prepended by PGXS) and use
# a minimal pg_config wrapper that only fixes --pgxs (native pg_config
# returns a path without the postgresql/ subdirectory).
PRE_COMPILE_TARGET = pgvector_pre_compile
COMPILE_MAKE_OPTIONS = -j1 \
	PG_CONFIG=$(WORK_DIR)/pg_config_wrapper \
	PG_CPPFLAGS="-I$(PGSQL_INC)/server -I$(PGSQL_INC)" \
	CC="$(TC_PATH)$(TC_PREFIX)gcc" \
	OPTFLAGS=""

include ../../mk/spksrc.cross-cc.mk

.PHONY: pgvector_pre_compile
pgvector_pre_compile:
	@printf '#!/bin/sh\n' > $(WORK_DIR)/pg_config_wrapper
	@printf 'case "$$1" in\n' >> $(WORK_DIR)/pg_config_wrapper
	@printf '  --pgxs) echo "$(NATIVE_PG_DIR)/lib/postgresql/pgxs/src/makefiles/pgxs.mk" ;;\n' >> $(WORK_DIR)/pg_config_wrapper
	@printf '  *)     exec "$(NATIVE_PG_DIR)/bin/pg_config" "$$@" ;;\n' >> $(WORK_DIR)/pg_config_wrapper
	@printf 'esac\n' >> $(WORK_DIR)/pg_config_wrapper
	@chmod +x $(WORK_DIR)/pg_config_wrapper

.PHONY: pgvector_install
pgvector_install:
	@$(MSG) "Installing pgvector extension files"
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib
	[ -f $(WORK_DIR)/$(PKG_DIR)/vector.so ] || { echo "vector.so not built"; exit 1; }
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/vector.so $(STAGING_INSTALL_PREFIX)/lib/
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/extension
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/vector.control $(STAGING_INSTALL_PREFIX)/share/extension/
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/sql/*.sql $(STAGING_INSTALL_PREFIX)/share/extension/
