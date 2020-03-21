SPK_NAME = rdiff-backup
SPK_VERS = 2.0.0
SPK_REV = 1
SPK_ICON = src/rdiff-backup.png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/$(SPK_NAME)
DEPENDS = cross/librsync
WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.6.8"

MAINTAINER = SynoCommunity
DESCRIPTION = A remote incremental backup of all your files
STARTABLE = no
DISPLAY_NAME = rdiff-backup
CHANGELOG = "Major new upstream release"
BETA = 1

HOMEPAGE = https://rdiff-backup.net
LICENSE  = GNU GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
