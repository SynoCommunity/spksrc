SPK_NAME = garage
SPK_VERS = 2.1.0
SPK_REV = 1
SPK_ICON = src/garage.png
DSM_UI_DIR = app

DEPENDS = cross/garage

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

MAINTAINER = fgma
DESCRIPTION = Garage is an S3-compatible distributed object storage service designed for self-hosting at a small-to-medium scale.
DISPLAY_NAME = Garage
CHANGELOG = "Initial version"
LICENSE_FILE = $(WORK_DIR)/garage/LICENSE
HOMEPAGE = https://garagehq.deuxfleurs.fr/
LICENSE = AGPLv3.0

WIZARDS_DIR = src/wizard

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_WIZARD_SHARE = wizard_data_directory
FWPORTS = src/garage.sc

SPK_COMMANDS = bin/garage

POST_STRIP_TARGET = garage-extras-install

include ../../mk/spksrc.spk.mk

.PHONY: garage-extras-install
garage-extras-install:
	install -m 644 src/garage_config_template.toml $(STAGING_DIR)/

