SPK_NAME = duplicity
SPK_VERS = 0.7.05
SPK_REV = 1
SPK_ICON = src/duplicity.png

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/boto cross/netifaces cross/wrapt cross/$(SPK_NAME)
DEPENDS = cross/librsync
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.8-9:gnupg>=2.1.6-1"

MAINTAINER = SynoCommunity
DESCRIPTION = Encrypted bandwidth-efficient backup using the rsync algorithm using a command line interface
STARTABLE = no
DISPLAY_NAME = Duplicity
CHANGELOG = "Initial release"
BETA = 1

HOMEPAGE = http://duplicity.nongnu.org/
LICENSE  = GNU GPL v2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = duplicity_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: duplicity_extra_install
duplicity_extra_install:
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/wheelhouse
	install -m 644 $(WORK_DIR)/wheelhouse/* $(STAGING_DIR)/share/wheelhouse/
