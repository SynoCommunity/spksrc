SPK_NAME = monit
SPK_VERS = 5.17.1
SPK_REV = 8
SPK_ICON = src/monit.png
DSM_UI_DIR = app
CHANGELOG = Update monit to 5.17.1
ADMIN_PORT = 2812
BETA = 1

DEPENDS =  cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Monit is a small Open Source utility for managing and monitoring Unix systems. Monit conducts automatic maintenance and repair and can execute meaningful causal actions in error situations.
RELOAD_UI = yes
DISPLAY_NAME = Monit

HOMEPAGE = http://mmonit.com/monit
LICENSE  = AGPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

WIZARDS_DIR = src/wizard/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = monit_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: monit_extra_install
monit_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/monit.d
	install -m 755 -d $(STAGING_DIR)/var/events
	install -m 700 src/monitrc $(STAGING_DIR)/var/monitrc
	install -m 700 src/monit.d/monit $(STAGING_DIR)/var/monit.d/monit
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/examples
	install -m 644 src/examples/* $(STAGING_DIR)/share/examples/
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
