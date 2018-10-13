SPK_NAME   = octoprint
SPK_VERS   = $(shell date +%Y%m%d)
SPK_REV    = 4
SPK_ICON   = src/octoprint.png
DSM_UI_DIR = app

BETA = 1

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel
DEPENDS = cross/$(SPK_NAME)
WHEELS  = src/requirements.txt

SPK_DEPENDS = "python>=2.7.11-15"

MAINTAINER   = SynoCommunity
DESCRIPTION  = OctoPrint is a so called host software for 3D printers that controls your 3D printer and sends it the actual commands to do its job.
ADMIN_PORT   = 8088
RELOAD_UI    = yes
DISPLAY_NAME = OctoPrint
HOMEPAGE     = http://octoprint.org/
LICENSE      = AGPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = octoprint_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: octoprint_extra_install
octoprint_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d ${STAGING_DIR}/var/.octoprint
	install -m 600 src/config.yaml ${STAGING_DIR}/var/.octoprint/config.yaml
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
