SPK_NAME = tt-rss
SPK_VERS = 17.4
SPK_REV = 11
SPK_ICON = src/tt-rss.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/$(SPK_NAME)

MAINTAINER = moneytoo
DESCRIPTION = Tiny Tiny RSS is an open source web-based news feed \(RSS/Atom\) reader and aggregator, designed to allow you to read news from any location, while feeling as close to a real desktop application as possible.
DESCRIPTION_FRE = Tiny Tiny RSS est un agrégateur et lecteur web de flux RSS et Atom open source conçu pour vous permettre de lire des nouvelles de n\\\'importe quel endroit, tout en se sentant aussi proche d\\\'une application de bureau que possible.
ADMIN_URL = /tt-rss/
RELOAD_UI = yes
DISPLAY_NAME = Tiny Tiny RSS
CHANGELOG = "Update Tiny Tiny RSS to Git revision 467bc4fe (17.4)"

HOMEPAGE   = http://tt-rss.org/
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

include ../../mk/spksrc.spk.mk

.PHONY: tt-rss_extra_install
tt-rss_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
