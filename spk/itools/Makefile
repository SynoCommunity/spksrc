SPK_NAME = itools
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/itools.png

DEPENDS = cross/usbmuxd cross/ifuse
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

MAINTAINER = bxxxjxxg
MAINTAINER_URL = https://www.linkedin.com/in/bingjing-chang/
DISTRIBUTOR = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com
DESCRIPTION = A collection toolkit for connecting iOS devices.
RELOAD_UI = n
DISPLAY_NAME = iTools
BETA = 1
CHANGELOG = First Release

HOMEPAGE   = https://www.libimobiledevice.org
LICENSE    = LGPL 2.1

SERVICE_SETUP   = src/service-setup.sh
SERVICE_COMMAND = $${SYNOPKG_PKGDEST}/sbin/usbmuxd
STARTABLE       = yes

include ../../mk/spksrc.spk.mk
