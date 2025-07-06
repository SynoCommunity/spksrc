SPK_NAME = adminer
SPK_VERS = 4.8.1
SPK_REV = 5
SPK_ICON = src/adminer.png
DSM_UI_DIR = app

DEPENDS = cross/adminer

MAINTAINER = piwi82
DESCRIPTION = Adminer is a full-featured database management tool available for MySQL, PostgreSQL, SQLite, MS SQL, Oracle, Firebird, SimpleDB, Elasticsearch and MongoDB.
DESCRIPTION_FRE = Adminer est un outil de gestion de base de données complet disponible pour MySQL, PostgreSQL, SQLite, MS SQL, Oracle, Firebird, SimpleDB, ElasticSearch et MongoDB.
ADMIN_URL = /adminer/
DISPLAY_NAME = Adminer
CHANGELOG = "1. Update to v4.8.1<br/>This package depends on Apache 2.4 and PHP 7.4 (except for DSM < 6)."

HOMEPAGE = https://www.adminer.org
LICENSE  = Apache 2.0 or GPLv2

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

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no
WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = adminer_extra_install

# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

include ../../mk/spksrc.spk.mk

.PHONY: adminer_extra_install
adminer_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/dot-htaccess-apache$(APACHE_VERSION) $(STAGING_DIR)/web/.htaccess
