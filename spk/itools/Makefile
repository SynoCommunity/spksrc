SPK_NAME = itools
SPK_VERS = 1.2
SPK_REV = 4
SPK_ICON = src/itools.png
# A collection of tools from ifuse and usbmuxd projects of libimobiledevice.org
# There exists no source code package "itools" and therefore no cross/itools project
DEPENDS = cross/usbmuxd cross/ifuse
SPK_DEPENDS = "PythonModule"

MAINTAINER = bxxxjxxg
MAINTAINER_URL = https://www.linkedin.com/in/bingjing-chang/
DISTRIBUTOR = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com
DESCRIPTION = "This package mounts an iOS® device \(connected by USB\) to a shared folder of your Diskstation. You can access such folders locally or from remote with Synology FileStation. Some command line tools are included to communicate with connected devices."
RELOAD_UI = no
DISPLAY_NAME = iOS Access
CHANGELOG = "Update openssl to 1.1."

HOMEPAGE   = https://www.libimobiledevice.org
LICENSE    = LGPL 2.1

SERVICE_SETUP   = src/service-setup.sh
SERVICE_COMMAND = $${SYNOPKG_PKGDEST}/sbin/usbmuxd
STARTABLE       = yes
# use custom privilege file: 
# use root for start/stop service to add/remove udev rule and to mount/umount devices
# omit SERVICE_USER (this would overwrite the privilege file with a generic one).
CONF_DIR        = src/conf

POST_STRIP_TARGET = itools_extra_install

SPK_COMMANDS  = bin/idevicebackup
SPK_COMMANDS += bin/idevicebackup2
SPK_COMMANDS += bin/idevicecrashreport
SPK_COMMANDS += bin/idevicedate
SPK_COMMANDS += bin/idevicedebug
SPK_COMMANDS += bin/idevicedebugserverproxy
SPK_COMMANDS += bin/idevicediagnostics
SPK_COMMANDS += bin/ideviceenterrecovery
SPK_COMMANDS += bin/idevice_id
SPK_COMMANDS += bin/ideviceimagemounter
SPK_COMMANDS += bin/ideviceinfo
SPK_COMMANDS += bin/idevicename
SPK_COMMANDS += bin/idevicenotificationproxy
SPK_COMMANDS += bin/idevicepair
SPK_COMMANDS += bin/ideviceprovision
SPK_COMMANDS += bin/idevicescreenshot
SPK_COMMANDS += bin/idevicesyslog
SPK_COMMANDS += bin/ifuse
SPK_COMMANDS += bin/inetcat
SPK_COMMANDS += bin/iproxy
SPK_COMMANDS += bin/plistutil


include ../../mk/spksrc.spk.mk

.PHONY: itools_extra_install
itools_extra_install:
	install -m 644 src/39-libimobiledevice.rules $(STAGING_DIR)/39-libimobiledevice.rules
	install -m 755 src/on-inserted.sh $(STAGING_DIR)/on-inserted.sh
	install -m 755 src/on-removed.sh $(STAGING_DIR)/on-removed.sh
	install -m 755 src/common.py $(STAGING_DIR)/common.py
	install -m 755 src/mounting.py $(STAGING_DIR)/mounting.py
	install -m 755 src/umounting.py $(STAGING_DIR)/umounting.py
