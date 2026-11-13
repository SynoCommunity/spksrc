SPK_NAME = postgresql
SPK_VERS = 17.12
SPK_REV = 7
SPK_ICON = src/postgresql.png

DEPENDS = cross/postgresql

MAINTAINER = DigitalBox98
DESCRIPTION = PostgreSQL is a powerful, open source object-relational database system with over 30 years of active development. This package includes PostGIS and pgvector extensions for DSM 7+.
CHANGELOG = "1. Update PostgreSQL to 17.12 (security fixes). <br/>2. Includes PostGIS 3.7.0 and pgvector 0.8.7"
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

# Each where its own floors admit the arch: PostGIS's through libgeos and libproj (gcc 8),
# pgvector's own (gcc 5).
$(call depend,cross/postgis,nop)
$(call depend,cross/pgvector,nop)

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
