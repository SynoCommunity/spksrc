SPK_NAME = itools
SPK_VERS = 1.1
SPK_REV = 2
SPK_ICON = src/itools.png

DEPENDS = cross/usbmuxd cross/ifuse
UNSUPPORTED_ARCHS = $(PPC_ARCHES)
SPK_DEPENDS = "PythonModule"

MAINTAINER = bxxxjxxg
MAINTAINER_URL = https://www.linkedin.com/in/bingjing-chang/
DISTRIBUTOR = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com
DESCRIPTION = A collection toolkit for connecting iOS devices.
RELOAD_UI = n
DISPLAY_NAME = iOS Access
CHANGELOG = Added udev rules and python scripts to auto-detect and mount/umount iOS devices into/from FileStation. 

HOMEPAGE   = https://www.libimobiledevice.org
LICENSE    = LGPL 2.1

SERVICE_SETUP   = src/service-setup.sh
SERVICE_COMMAND = $${SYNOPKG_PKGDEST}/sbin/usbmuxd
STARTABLE       = yes

POST_STRIP_TARGET = itools_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: itools_extra_install
itools_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/run/
	install -m 755 -d $(STAGING_DIR)/var/log/
	install -m 644 src/39-libimobiledevice.rules $(STAGING_DIR)/39-libimobiledevice.rules
	install -m 755 src/on-inserted.sh $(STAGING_DIR)/on-inserted.sh
	install -m 755 src/on-removed.sh $(STAGING_DIR)/on-removed.sh
	install -m 755 src/common.py $(STAGING_DIR)/common.py
	install -m 755 src/mounting.py $(STAGING_DIR)/mounting.py
	install -m 755 src/umounting.py $(STAGING_DIR)/umounting.py
