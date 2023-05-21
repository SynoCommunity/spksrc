SPK_NAME = itools
SPK_VERS = 2.0
SPK_REV = 5
SPK_ICON = src/itools.png

# since cross/libplist 2.3.0
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

# A collection of tools from ifuse and usbmuxd projects of libimobiledevice.org
# There exists no source code package "itools" and therefore no cross/itools project
# current versions listed on https://libimobiledevice.org/#downloads
DEPENDS = cross/usbmuxd cross/ifuse

# REMARKS:
# this package needs a redesign
# - how to use this package on DSM 7+ without root access for the packages?
# - python scripts are python2 only: update for python3 - or other solution (the referenced lockfile module is for python <= 3.3)

MAINTAINER = bxxxjxxg
MAINTAINER_URL = https://www.linkedin.com/in/bingjing-chang/
DISTRIBUTOR = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com
DESCRIPTION = "This package contains tools of libimobiledevice to mount an iOS® device \(connected by USB\) to a shared folder of your Diskstation. You can access such folders locally or from remote with Synology FileStation. Some command line tools are included to communicate with connected devices."
DISPLAY_NAME = iOS Access
CHANGELOG = "1. Update usb tools and imobile device libraries to v2.0<br/>2. Update openssl to v3.1.0."

HOMEPAGE = https://www.libimobiledevice.org
LICENSE = LGPL 2.1

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, $(TCVERSION), 7.0),1)

STARTABLE = yes

# use custom privilege file: 
# use root for start/stop service to add/remove udev rule and to mount/umount devices
# omit SERVICE_USER (this would overwrite the privilege file with a generic one).
CONF_DIR = src/conf

else

# service needs root access and is not supported on DSM >= 7
STARTABLE = no

endif

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
