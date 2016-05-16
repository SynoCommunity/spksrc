SPK_NAME = adminer
SPK_VERS = 4.2.4
SPK_REV = 1
SPK_ICON = src/adminer.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = piwi82
DESCRIPTION = Adminer is a full-featured database management tool available for MySQL, PostgreSQL, SQLite, MS SQL, Oracle, Firebird, SimpleDB, Elasticsearch and MongoDB.
DESCRIPTION_FRE = Adminer est un outil de gestion de base de données complet disponible pour MySQL, PostgreSQL, SQLite, MS SQL, Oracle, Firebird, SimpleDB, ElasticSearch et MongoDB.
ADMIN_URL = /adminer/
RELOAD_UI = yes
DISPLAY_NAME = Adminer
CHANGELOG = Initial release of Adminer 4.2.4

HOMEPAGE   = https://www.adminer.org
LICENSE    = Apache License 2.0 or GPL 2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = adminer_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: adminer_extra_install
adminer_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
			$(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
