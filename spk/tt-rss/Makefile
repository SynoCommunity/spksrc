SPK_NAME = tt-rss
SPK_VERS = 20230828
SPK_REV = 17
SPK_ICON = src/tt-rss.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)
SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0

MAINTAINER = moneytoo
DESCRIPTION = Tiny Tiny RSS is an open source web-based news feed \(RSS/Atom\) reader and aggregator, designed to allow you to read news from any location, while feeling as close to a real desktop application as possible.
DESCRIPTION_FRE = Tiny Tiny RSS est un agrégateur et lecteur web de flux RSS et Atom open source conçu pour vous permettre de lire des nouvelles de n\'importe quel endroit, tout en se sentant aussi proche d\'une application de bureau que possible.
CHANGELOG = "Update Tiny Tiny RSS to Git revision afd04d141c (20230828)"
DISPLAY_NAME = Tiny Tiny RSS

HOMEPAGE   = https://tt-rss.org/
LICENSE    = GPL

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

SYSTEM_GROUP = http

ADMIN_URL = /tt-rss/

WIZARDS_TEMPLATES_DIR = src/wizard_templates
CONF_DIR = src/conf/

include ../../mk/spksrc.common.mk

# Alternate conf dir for DSM 6
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
CONF_DIR = src/conf_6/
endif

POST_STRIP_TARGET = tt-rss_extra_install

PHP_EXTENSIONS := $(shell jq -r '.webservice.services[0].php.extensions[]' src/conf/resource)

override ARCH=

include ../../mk/spksrc.spk.mk

$(STAGING_DIR)/etc/php/conf.d/com.synocommunity.tt-rss.ini: 
	@$(MSG) Generating $@
	$(create_target_dir)
	$(foreach extension,$(PHP_EXTENSIONS),echo "extension=$(extension).so" >> $@;)

.PHONY: tt-rss_extra_install
tt-rss_extra_install: $(STAGING_DIR)/etc/php/conf.d/com.synocommunity.tt-rss.ini
	install -m 755 -d $(STAGING_DIR)/app -d $(STAGING_DIR)/web
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/web/tt-rss.conf $(STAGING_DIR)/web/tt-rss.conf
	install -m 644 src/web/tt-rss.json $(STAGING_DIR)/web/tt-rss.json
