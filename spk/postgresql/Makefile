SPK_NAME = postgresql
SPK_VERS = 11.22
SPK_REV = 3
SPK_ICON = src/postgresql.png

DEPENDS = cross/postgresql

MAINTAINER = DigitalBox98
DESCRIPTION = PostgreSQL is a powerful, open source object-relational database system with over 30 years of active development that has earned it a strong reputation for reliability, feature robustness, and performance.
CHANGELOG = "Initial package release."
DISPLAY_NAME = PostgreSQL
STARTABLE = yes

HOMEPAGE = https://www.postgresql.com
LICENSE = PostgreSQL Licence

include ../../mk/spksrc.common.mk
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
CONF_DIR = src/conf
WIZARDS_DIR = src/wizard.dsm7
SERVICE_SETUP = src/service-setup.sh
else
CONF_DIR = src/conf.root
WIZARDS_DIR = src/wizard
SERVICE_SETUP = src/service-setup.as-root.sh
endif

# sc-postgresql is not a valid user (sc_postgres is defined in privilege file as package/service user)
#SERVICE_USER=auto
SSS_SCRIPT = src/start-stop-status.sh

include ../../mk/spksrc.spk.mk
