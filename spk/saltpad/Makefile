SPK_NAME = saltpad
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 3
SPK_ICON = src/saltpad.png
DSM_UI_DIR = app

DEPENDS =
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.9-12:salt-master"

MAINTAINER = SynoCommunity
DESCRIPTION = A gui and cli to manage saltstack deployments 
ADMIN_PORT = 8283
RELOAD_UI = yes
DISPLAY_NAME = SaltPad
START_DEP_SERVICES = salt-master

HOMEPAGE   = https://github.com/tinyclues/saltpad
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = saltpad_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: saltpad_extra_install
saltpad_extra_install: $(STAGING_DIR)/share/saltpad
	install -m 755 -d $(STAGING_DIR)/var

$(STAGING_DIR)/share/saltpad:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/tinyclues/saltpad.git saltpad
