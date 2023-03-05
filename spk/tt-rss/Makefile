SPK_NAME = tt-rss
SPK_VERS = 20221230
SPK_REV = 16
SPK_ICON = src/tt-rss.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = moneytoo
DESCRIPTION = Tiny Tiny RSS is an open source web-based news feed \(RSS/Atom\) reader and aggregator, designed to allow you to read news from any location, while feeling as close to a real desktop application as possible.
DESCRIPTION_FRE = Tiny Tiny RSS est un agrégateur et lecteur web de flux RSS et Atom open source conçu pour vous permettre de lire des nouvelles de n\'importe quel endroit, tout en se sentant aussi proche d\'une application de bureau que possible.
ADMIN_URL = /tt-rss/
DISPLAY_NAME = Tiny Tiny RSS
CHANGELOG = "1. Update Tiny Tiny RSS to Git revision c30b24d09f (20221230) <br /> 2. Fixed broken DSM 7 initial installation procedure. <br /> 3. Upgrade PHP version to 7.4"

HOMEPAGE   = https://tt-rss.org/
LICENSE    = GPL

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf/

SERVICE_SETUP = src/service-setup.sh
SYSTEM_GROUP	 = http

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql

SERVICE_COMMAND = $(INSTALL_PREFIX)/bin/tt-rss-daemon

POST_STRIP_TARGET = tt-rss_extra_install

PHP_EXTENSIONS = curl gd intl mysqli pdo_mysql posix

override ARCH=

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0
INSTUNINST_RESTART_SERVICES = apache-web

SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"

include ../../mk/spksrc.spk.mk

$(STAGING_DIR)/etc/php/conf.d/com.synocommunity.tt-rss.ini: 
	@$(MSG) Generating $@
	$(create_target_dir)
	$(foreach extension,$(PHP_EXTENSIONS),echo "extension=$(extension).so" >> $@;)

.PHONY: tt-rss_extra_install
tt-rss_extra_install: $(STAGING_DIR)/etc/php/conf.d/com.synocommunity.tt-rss.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/bin/tt-rss-daemon $(STAGING_DIR)/bin/tt-rss-daemon
	install -m 755 src/bin/virtual-php $(STAGING_DIR)/bin/virtual-php
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
	install -m 644 src/bin/7.0/settings.sh $(STAGING_DIR)/bin/settings.sh
	install -m 755 src/bin/7.0/update-schema $(STAGING_DIR)/bin/update-schema
else
	install -m 644 src/bin/settings.sh $(STAGING_DIR)/bin/settings.sh
	install -m 755 src/bin/update-schema $(STAGING_DIR)/bin/update-schema
endif
