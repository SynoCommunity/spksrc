SPK_NAME   = octoprint
SPK_VERS   = 1.6.0
SPK_REV    = 5
SPK_ICON   = src/octoprint.png
DSM_UI_DIR = app

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS = cross/$(SPK_NAME)
WHEELS  = src/requirements.txt
PIP = pip3

SPK_DEPENDS = "python3>=3.7"

MAINTAINER   = SynoCommunity
DESCRIPTION  = The snappy web interface for your 3D printer.
ADMIN_PORT   = 8088
RELOAD_UI    = yes
DISPLAY_NAME = OctoPrint
HOMEPAGE     = https://octoprint.org/
LICENSE      = AGPLv3
CHANGELOG    = "Update OctoPrint to v1.6.0 and python3"

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/$(SPK_NAME).sc
CONF_DIR         = src/conf/

POST_STRIP_TARGET = octoprint_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: octoprint_extra_install
octoprint_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/.octoprint
	install -m 600 src/config.yaml $(STAGING_DIR)/var/.octoprint/config.yaml
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
