SPK_NAME = selfoss
SPK_VERS = 2.13
SPK_REV = 6
SPK_ICON = src/selfoss.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/$(SPK_NAME)

MAINTAINER = moneytoo
DESCRIPTION = The new multipurpose rss reader, live stream, mashup, aggregation web application.
ADMIN_URL = /selfoss/
RELOAD_UI = yes
DISPLAY_NAME = Selfoss
CHANGELOG = "1. Update Selfoss to 2.13<br>2. Fix DSM4.3 compatibility"

HOMEPAGE   = http://selfoss.aditu.de/
LICENSE    = GPLv3

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = selfoss_extra_install

BUSYBOX_CONFIG = daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: selfoss_extra_install
selfoss_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 src/selfoss.sh $(STAGING_DIR)/bin/
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
