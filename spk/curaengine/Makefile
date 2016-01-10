SPK_NAME = curaengine
SPK_VERS = 15.04
SPK_REV = 1
SPK_ICON = src/curaengine.png
BETA = 1

DEPENDS = cross/$(SPK_NAME)
REQUIRED_DSM = 5.0

MAINTAINER = SynoCommunity
DESCRIPTION  = CuraEngine is a powerful, fast and robust engine for processing 3D models into 3D printing instruction for Ultimaker and other GCode based 3D printers.
STARTABLE = no
DISPLAY_NAME = CuraEngine

HOMEPAGE = https://ultimaker.com
LICENSE  = AGPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
