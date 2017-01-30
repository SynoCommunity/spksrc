SPK_NAME = duplicity
SPK_VERS = 0.7.11
SPK_REV = 4
SPK_ICON = src/duplicity.png

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/$(SPK_NAME)
DEPENDS = cross/librsync cross/bash cross/duply
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.8-9:gnupg>=2.1.6-1"

MAINTAINER = SynoCommunity
DESCRIPTION = Encrypted bandwidth-efficient backup using the rsync algorithm using a command line interface. Also contains duply wrapper script.
STARTABLE = no
DISPLAY_NAME = Duplicity
CHANGELOG = "1. Upgraded Duplicity to 0.7.11<br>2. Upgraded Duply to 2.0.1"
BETA = 1

HOMEPAGE = http://duplicity.nongnu.org/
LICENSE  = GNU GPL v2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

