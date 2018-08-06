SPK_NAME = iOSAccess
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/icon.png

DEPENDS =
WHEELS = src/requirements.txt
SPK_DEPENDS = "PythonModule:itools"

MAINTAINER = bxxxjxxg
MAINTAINER_URL = https://www.linkedin.com/in/bingjing-chang/
DISTRIBUTOR = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com
DESCRIPTION = iOS Access provides udev rules and python scripts to auto-detect and mount/umount iOS devices into/from FileStation.
RELOAD_UI = n
DISPLAY_NAME = iOS Access
STARTABLE = yes
BETA = 1
CHANGELOG = First Release

HOMEPAGE  = https://synocommunity.com
LICENSE   = LGPL 2.1

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

POST_STRIP_TARGET = ios_access_extra_install

override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: ios_access_extra_install
ios_access_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/run/
	install -m 755 -d $(STAGING_DIR)/var/log/
	install -m 644 src/39-libimobiledevice.rules $(STAGING_DIR)/39-libimobiledevice.rules
	install -m 755 src/on-inserted.sh $(STAGING_DIR)/on-inserted.sh
	install -m 755 src/on-removed.sh $(STAGING_DIR)/on-removed.sh
	install -m 755 src/common.py $(STAGING_DIR)/common.py
	install -m 755 src/mounting.py $(STAGING_DIR)/mounting.py
	install -m 755 src/umounting.py $(STAGING_DIR)/umounting.py
