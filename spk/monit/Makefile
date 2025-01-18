SPK_NAME = monit
SPK_VERS = 5.34.4
SPK_REV = 11
SPK_ICON = src/monit.png
DSM_UI_DIR = app

DEPENDS = cross/monit

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

BETA = 1

MAINTAINER = SynoCommunity
DESCRIPTION = Monit is a small Open Source utility for managing and monitoring Unix systems. Monit conducts automatic maintenance and repair and can execute meaningful causal actions in error situations.
DISPLAY_NAME = Monit
CHANGELOG = "1. Update monit to v5.34.4 <br/>2. Update OpenSSL to v3.1.7."

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
	@install -m 755 -d $(STAGING_DIR)/var/monit.d $(STAGING_DIR)/var/events $(STAGING_DIR)/share/examples
	@install -m 700 src/monitrc $(STAGING_DIR)/var/monitrc
	@install -m 700 src/monit.d/monit $(STAGING_DIR)/var/monit.d/monit
	@install -m 644 src/examples/* $(STAGING_DIR)/share/examples/
