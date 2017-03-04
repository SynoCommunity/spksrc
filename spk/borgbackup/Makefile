SPK_NAME = borgbackup
SPK_VERS = 1.0.10
SPK_REV = 2
SPK_ICON = src/$(SPK_NAME).png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/$(SPK_NAME)
DEPENDS = cross/bash
WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.5.2-6"

MAINTAINER = SynoCommunity
DESCRIPTION = Deduplicating backup program with compression and authenticated encryption.
STARTABLE = no
DISPLAY_NAME = Borg
CHANGELOG = "1. First release<br>2. Add borgmatic"
BETA = 1

HOMEPAGE = https://borgbackup.readthedocs.io
LICENSE  = Borg

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
