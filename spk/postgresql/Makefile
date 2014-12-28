SPK_NAME = postgresql
SPK_VERS = 9.3
SPK_REV = 1
SPK_ICON = src/icon.png
BETA = 1

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = PostgreSQL is a powerful, open source object-relational database system.
RELOAD_UI = no
DISPLAY_NAME = PostgreSQL
CHANGELOG = "Initial release"

HOMEPAGE   = http://www.postgresql.org/
LICENSE    = 

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = postgresql_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: postgresql_extra_install
postgresql_extra_install:
	install -m 757 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc

	install -m 644 src/pg_hba.conf $(STAGING_DIR)/etc/pg_hba.conf
	install -m 644 src/pg_ident.conf $(STAGING_DIR)/etc/pg_ident.conf
	install -m 644 src/postgresql.conf $(STAGING_DIR)/etc/postgresql.conf

