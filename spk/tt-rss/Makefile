SPK_NAME = tt-rss
SPK_VERS = 20230828
SPK_REV = 18
SPK_ICON = src/tt-rss.png

DEPENDS  = cross/tt-rss
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"

MAINTAINER = moneytoo
DESCRIPTION = Tiny Tiny RSS is an open source web-based news feed \(RSS/Atom\) reader and aggregator, designed to allow you to read news from any location, while feeling as close to a real desktop application as possible.
DESCRIPTION_FRE = Tiny Tiny RSS est un agrégateur et lecteur web de flux RSS et Atom open source conçu pour vous permettre de lire des nouvelles de n\'importe quel endroit, tout en se sentant aussi proche d\'une application de bureau que possible.
DISPLAY_NAME = Tiny Tiny RSS
CHANGELOG = "1. Update Tiny Tiny RSS to Git revision afd04d141c (20230828).<br/>2. Fix for DSM 6 app startup."

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
CONF_DIR = src/conf/

include ../../mk/spksrc.common.mk

# Alternate conf dir for DSM 6
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
CONF_DIR = src/conf_6/
endif

POST_STRIP_TARGET = tt-rss_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: tt-rss_extra_install
tt-rss_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/tt-rss.conf $(STAGING_DIR)/web/tt-rss.conf
	install -m 644 src/web/tt-rss.json $(STAGING_DIR)/web/tt-rss.json
