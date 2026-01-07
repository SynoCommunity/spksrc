SPK_NAME = tt-rss
SPK_VERS = 20230828
SPK_REV = 20
SPK_ICON = src/tt-rss.png

DEPENDS  = cross/tt-rss
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0
# SRM is not supported due lacking webstation, php, mariadb and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = moneytoo
DESCRIPTION = Tiny Tiny RSS is an open source web-based news feed \(RSS/Atom\) reader and aggregator, designed to allow you to read news from any location, while feeling as close to a real desktop application as possible.
DESCRIPTION_FRE = Tiny Tiny RSS est un agrégateur et lecteur web de flux RSS et Atom open source conçu pour vous permettre de lire des nouvelles de n\'importe quel endroit, tout en se sentant aussi proche d\'une application de bureau que possible.
DISPLAY_NAME = Tiny Tiny RSS
CHANGELOG = "1. Align PHP dependency handling with DSM 6/7 (PHP 7.4/8.0/8.2) and harden service script."

HOMEPAGE   = https://tt-rss.org/
LICENSE    = GPL

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

ADMIN_URL = /tt-rss/

WIZARDS_TEMPLATES_DIR = src/wizard_templates
SYSTEM_GROUP = http

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

include ../../mk/spksrc.common.mk

# DSM-specific PHP profiles
ifeq ($(call version_ge, ${TCVERSION}, 7.2),1)
SPK_DEPENDS = "WebStation:PHP8.2:MariaDB10:Apache2.4"
CONF_DIR = src/conf_72/
else ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
SPK_DEPENDS = "WebStation:PHP8.0:MariaDB10:Apache2.4"
OS_MAX_VER = 7.1-59999
CONF_DIR = src/conf_7/
else
SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"
CONF_DIR = src/conf_6/
endif

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
POST_STRIP_TARGET = tt-rss_extra_install
endif

include ../../mk/spksrc.spk.mk

.PHONY: tt-rss_extra_install
tt-rss_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/tt-rss.conf $(STAGING_DIR)/web/tt-rss.conf
	install -m 644 src/web/tt-rss.json $(STAGING_DIR)/web/tt-rss.json
