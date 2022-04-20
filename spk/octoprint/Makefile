SPK_NAME   = octoprint
SPK_VERS   = 1.7.3
SPK_REV    = 8
SPK_ICON   = src/octoprint.png
DSM_UI_DIR = app

BUILD_DEPENDS = cross/python310

# Required for PyYAML
DEPENDS += cross/libyaml

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

SPK_DEPENDS = "python310"

MAINTAINER   = SynoCommunity
DESCRIPTION  = The snappy web interface for your 3D printer.
SERVICE_PORT = 8088
ADMIN_PORT   = $(SERVICE_PORT)

DISPLAY_NAME = OctoPrint
HOMEPAGE     = https://octoprint.org/
LICENSE      = AGPLv3
CHANGELOG    = "1. Update OctoPrint to v1.7.3<br/>2. Update to Python 3.10"

# SERVICE_COMMAND is in src/service-setup.sh
STARTABLE     = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_USER  = auto

POST_STRIP_TARGET = octoprint_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: octoprint_extra_install
octoprint_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/.octoprint
	install -m 600 src/config.yaml $(STAGING_DIR)/var/.octoprint/config.yaml
