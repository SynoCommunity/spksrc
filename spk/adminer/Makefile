SPK_NAME = adminer
SPK_VERS = 5.4.1
SPK_REV = 8
SPK_ICON = src/adminer.png
DSM_UI_DIR = app

DEPENDS = cross/adminer

# SRM is lacking webstation and php
REQUIRED_MIN_SRM = 3.0

MAINTAINER = piwi82
DESCRIPTION = Adminer is a full-featured database management tool available for MySQL, PostgreSQL, SQLite, MS SQL, Oracle, Firebird, SimpleDB, Elasticsearch and MongoDB.
DESCRIPTION_FRE = Adminer est un outil de gestion de base de données complet disponible pour MySQL, PostgreSQL, SQLite, MS SQL, Oracle, Firebird, SimpleDB, ElasticSearch et MongoDB.
ADMIN_URL = /adminer/
DISPLAY_NAME = Adminer
CHANGELOG = "1. Update to v5.4.1. <br/>This package depends on Apache 2.4 (DSM >= 6) and PHP 8.2 (DSM 7.2) or PHP 8.0 (DSM 7.0-7.1) or PHP 7.4 (DSM 6)."

HOMEPAGE = https://www.adminer.org
LICENSE  = Apache 2.0 or GPLv2

include ../../mk/spksrc.common.mk
##
## This package can be built for DSM <6.0, DSM >=6.1;<7.0, DSM >=7.0;<7.2 and DSM >=7.2
## To build all versions call:
## noarch-3.1 && make noarch-6.1 && make noarch-7.0 && make noarch-7.2
##
ifeq ($(call version_ge, ${TCVERSION}, 6.0),1)
ifeq ($(call version_ge, ${TCVERSION}, 7.2),1)
SPK_DEPENDS = "WebStation:PHP8.2:Apache2.4"
# DSM >= 7.2
CONF_DIR = src/conf_dsm72
else ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
SPK_DEPENDS = "WebStation:PHP8.0:Apache2.4"
# DSM >= 7.3 does not support PHP8.0
OS_MAX_VER = 7.1-59999
# DSM 7.0 and 7.1
CONF_DIR = src/conf_dsm7
else
# DSM 6
SPK_DEPENDS = "WebStation:PHP7.4:Apache2.4"
endif
APACHE_VERSION = 2.4
SYSTEM_GROUP = http
else
APACHE_VERSION = 2.2
endif

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
WIZARDS_DIR = src/wizard7/
else
WIZARDS_DIR = src/wizard/
endif

POST_STRIP_TARGET = adminer_extra_install

# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

include ../../mk/spksrc.spk.mk

.PHONY: adminer_extra_install
adminer_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/dot-htaccess-apache$(APACHE_VERSION) $(STAGING_DIR)/web/.htaccess
