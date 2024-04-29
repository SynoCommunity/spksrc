SPK_NAME = monit
SPK_VERS = 5.29.0
SPK_REV = 10
SPK_ICON = src/monit.png
DSM_UI_DIR = app

DEPENDS =  cross/$(SPK_NAME)

UNSUPPORTED_ARCHS = PPC_ARCHS

BETA = 1

MAINTAINER = SynoCommunity
DESCRIPTION = Monit is a small Open Source utility for managing and monitoring Unix systems. Monit conducts automatic maintenance and repair and can execute meaningful causal actions in error situations.
DISPLAY_NAME = Monit
CHANGELOG = "1. Update monit to v5.29.0<br/>2. Update OpenSSL to v1.1.1l"

HOMEPAGE = https://mmonit.com/monit
LICENSE  = AGPLv3

STARTABLE = yes
WIZARDS_DIR = src/wizard

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
FWPORTS = src/monit.sc
ADMIN_PORT = 2812

POST_STRIP_TARGET = monit_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: monit_extra_install
monit_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/monit.d
	install -m 755 -d $(STAGING_DIR)/var/events
	install -m 700 src/monitrc $(STAGING_DIR)/var/monitrc
	install -m 700 src/monit.d/monit $(STAGING_DIR)/var/monit.d/monit
	install -m 755 -d $(STAGING_DIR)/share/examples
	install -m 644 src/examples/* $(STAGING_DIR)/share/examples/
