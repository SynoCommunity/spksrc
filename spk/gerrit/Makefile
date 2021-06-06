SPK_NAME = gerrit
SPK_VERS = 2.13.3
SPK_REV = 1
SPK_ICON = src/gerrit.png
DSM_UI_DIR = app

REQUIRED_DSM = 5.0
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

DEPENDS = cross/busybox cross/gerrit
SPK_DEPENDS = "JavaManager:git"

MAINTAINER = SynoCommunity
DESCRIPTION = Gerrit provides web based code review and repository management for the Git version control system.
ADMIN_PROTOCOL = https
ADMIN_PORT = 8141
STARTABLE = yes
RELOAD_UI = yes
DISPLAY_NAME = Gerrit

LICENSE = Apache 2.0
HOMEPAGE = "https://gerritcodereview.com"

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT = src/dsm-control.sh
FWPORTS = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = gerrit_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: gerrit_extra_install
gerrit_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 -d $(STAGING_DIR)/lib
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 600 src/gerrit.config $(STAGING_DIR)/etc/gerrit.config

