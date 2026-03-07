SPK_NAME = postgresql
SPK_VERS = 17.4
SPK_REV = 1
SPK_ICON = src/postgresql.png

DEPENDS = cross/postgresql cross/postgis

MAINTAINER = DigitalBox98
DESCRIPTION = PostgreSQL is a powerful, open source object-relational database system with over 30 years of active development. This package includes PostGIS spatial database extension.
CHANGELOG = "Initial package release."
DISPLAY_NAME = PostgreSQL
STARTABLE = yes

HOMEPAGE = https://www.postgresql.org
LICENSE = PostgreSQL Licence

# Default port (Synology uses 5432, so we use 5433)
SERVICE_PORT = 5433
SERVICE_PORT_TITLE = PostgreSQL
# PostgreSQL uses its own protocol, not HTTP - no web UI shortcut
NO_SERVICE_SHORTCUT = 1

include ../../mk/spksrc.common.mk

# libicu dependency doesn't support ARMv5/OLD_PPC (no DSM 7.x toolchains)
# comcerto2k: DSM 7.x toolchain uses GCC 4.9.3 (GEOS 3.12.3 requires C++14/GCC 5+)
UNSUPPORTED_ARCHS = comcerto2k
# DSM < 7.0: GCC 4.9 fails PostGIS libpq detection (strict linker requires SSL libs)
REQUIRED_MIN_DSM = 7.0

# Common PostgreSQL commands available via /usr/local/bin/
SPK_COMMANDS  = bin/psql
SPK_COMMANDS += bin/pg_dump
SPK_COMMANDS += bin/pg_dumpall
SPK_COMMANDS += bin/pg_restore
SPK_COMMANDS += bin/createdb
SPK_COMMANDS += bin/dropdb
SPK_COMMANDS += bin/createuser
SPK_COMMANDS += bin/dropuser
SPK_COMMANDS += bin/pg_isready
SPK_COMMANDS += bin/vacuumdb
SPK_COMMANDS += bin/reindexdb
SPK_COMMANDS += bin/clusterdb

# Use auto-generated service user (sc-postgresql)
SERVICE_USER = auto

SERVICE_SETUP = src/service-setup.sh
WIZARDS_DIR = src/wizard
SSS_SCRIPT = src/start-stop-status.sh

include ../../mk/spksrc.spk.mk
