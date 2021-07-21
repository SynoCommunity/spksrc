SPK_NAME = adminer
SPK_VERS = 4.8.0
SPK_REV = 4
SPK_ICON = src/adminer.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = piwi82
DESCRIPTION = Adminer is a full-featured database management tool available for MySQL, PostgreSQL, SQLite, MS SQL, Oracle, Firebird, SimpleDB, Elasticsearch and MongoDB.
DESCRIPTION_FRE = Adminer est un outil de gestion de base de données complet disponible pour MySQL, PostgreSQL, SQLite, MS SQL, Oracle, Firebird, SimpleDB, ElasticSearch et MongoDB.
ADMIN_URL = /adminer/
DISPLAY_NAME = Adminer
CHANGELOG = "1. Update to 4.8.0<br/>This package depends on Apache 2.4 and PHP 7.4 (except for DSM < 6)."

HOMEPAGE = https://www.adminer.org
LICENSE  = Apache License 2.0 or GPL 2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT = src/dsm-control.sh
WIZARDS_DIR = src/wizard/

include ../../mk/spksrc.common.mk

##
## This package can be built for DSM <6.0, DSM >=6.0;<7.0 and DSM >=7.0
## To build all versions call:
## make && make TCVERSION=6.0 && make TCVERSION=7.0 
##

ifeq ($(call version_ge, ${TCVERSION}, 6.0),1)
SPK_DEPENDS = "WebStation>=2.1.0:PHP7.4>=7.4.0:Apache2.4>=2.4.0"
CONF_DIR = src/conf
APACHE_VERSION = 2.4
else
APACHE_VERSION = 2.2
endif

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web
SYSTEM_GROUP = http

POST_STRIP_TARGET = adminer_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: adminer_extra_install
adminer_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/dot-htaccess-apache$(APACHE_VERSION) $(STAGING_DIR)/web/.htaccess
