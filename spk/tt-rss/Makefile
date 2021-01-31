SPK_NAME = tt-rss
SPK_VERS = 20201114
SPK_REV = 13
SPK_ICON = src/tt-rss.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/$(SPK_NAME)

MAINTAINER = moneytoo
DESCRIPTION = Tiny Tiny RSS is an open source web-based news feed \(RSS/Atom\) reader and aggregator, designed to allow you to read news from any location, while feeling as close to a real desktop application as possible.
DESCRIPTION_FRE = Tiny Tiny RSS est un agrégateur et lecteur web de flux RSS et Atom open source conçu pour vous permettre de lire des nouvelles de n\'importe quel endroit, tout en se sentant aussi proche d\'une application de bureau que possible.
ADMIN_URL = /tt-rss/
RELOAD_UI = yes
DISPLAY_NAME = Tiny Tiny RSS
CHANGELOG = "
CHANGELOG += 1. Update Tiny Tiny RSS to Git revision 328d7b55c8 (20201114).<br />
CHANGELOG += 2. add troubleshooting logs generation.<br />
CHANGELOG += 3. fixed access rights issue occurring when upgrading on a live installation.<br />
CHANGELOG += "

HOMEPAGE   = https://tt-rss.org/
LICENSE    = GPL

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = tt-rss_extra_install

BUSYBOX_CONFIG = daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

PHP_EXTENSIONS = curl gd intl mysqli pdo_mysql posix

# Due to not obvious WebStation handling requirements
REQUIRED_DSM = 6.0

INSTUNINST_RESTART_SERVICES = apache-web

SPK_DEPENDS = "WebStation"

include ../../mk/spksrc.spk.mk

$(STAGING_DIR)/etc/php/conf.d/com.synocommunity.tt-rss.ini: 
	@$(MSG) Generating $@
	$(create_target_dir)
	$(foreach extension,$(PHP_EXTENSIONS),echo "extension=$(extension).so" >> $@;)

.PHONY: tt-rss_extra_install
tt-rss_extra_install: $(STAGING_DIR)/etc/php/conf.d/com.synocommunity.tt-rss.ini
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/logs
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/bin/settings.sh $(STAGING_DIR)/bin/settings.sh
	install -m 755 src/bin/tt-rss-daemon $(STAGING_DIR)/bin/tt-rss-daemon
	install -m 755 src/bin/update-schema $(STAGING_DIR)/bin/update-schema
	install -m 755 src/bin/virtual-php $(STAGING_DIR)/bin/virtual-php

