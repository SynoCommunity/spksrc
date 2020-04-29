SPK_NAME = rdiff-backup
SPK_VERS = 2.0.0
SPK_REV = 2
SPK_ICON = src/rdiff-backup.png

PIP = pip3
BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS = cross/librsync cross/attr cross/acl
WHEELS = src/requirements.txt

SPK_DEPENDS = "python3>=3.5"

MAINTAINER = SynoCommunity
DESCRIPTION = rdiff-backup is reverse differential backup.
STARTABLE = no
DISPLAY_NAME = rdiff-backup
CHANGELOG = "Update to v2.0.0 and update dependencies for python3."
BETA = 1

HOMEPAGE = https://rdiff-backup.net/
LICENSE  = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

