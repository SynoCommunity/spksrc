SPK_NAME   = octoprint
SPK_VERS   = 1.9.2
SPK_REV    = 11
SPK_ICON   = src/octoprint.png
DSM_UI_DIR = app

BUILD_DEPENDS = cross/python311

# Required for PyYAML
DEPENDS += cross/libyaml

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

SPK_DEPENDS = "python311>=3.11.4-7"

MAINTAINER   = SynoCommunity
DESCRIPTION  = The snappy web interface for your 3D printer.
SERVICE_PORT = 8088
ADMIN_PORT   = $(SERVICE_PORT)

DISPLAY_NAME = OctoPrint
HOMEPAGE     = https://octoprint.org/
LICENSE      = AGPLv3
CHANGELOG    = "Update OctoPrint to v1.9.2 and Python dependency to 3.11."

# SERVICE_COMMAND is in src/service-setup.sh
STARTABLE     = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_USER  = auto

POST_STRIP_TARGET = octoprint_extra_install

# /tmp might be too small for plugin installation
USE_ALTERNATE_TMPDIR = 1

# [frozendict]
WHEELS_CFLAGS = [frozendict] --std=c99

include ../../mk/spksrc.spk.mk

.PHONY: octoprint_extra_install
octoprint_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/.octoprint
	install -m 600 src/config.yaml $(STAGING_DIR)/var/.octoprint/config.yaml
