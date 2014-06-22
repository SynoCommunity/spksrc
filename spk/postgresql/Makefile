SPK_NAME = postgresql
SPK_VERS = 9.3
SPK_REV = 1
SPK_ICON = src/icon.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  = 

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
COPY_TARGET = nop

POST_STRIP_TARGET = dnsmasqproxy_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: dnsmasqproxy_extra_install
dnsmasqproxy_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 757 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/bin

	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/pg_hba.conf $(STAGING_DIR)/etc/pg_hba.conf
	install -m 644 src/pg_ident.conf $(STAGING_DIR)/etc/pg_ident.conf
	install -m 644 src/postgresql.conf $(STAGING_DIR)/etc/postgresql.conf

	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
        convert $(SPK_ICON) -thumbnail $${size}x$${size} \
                $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
