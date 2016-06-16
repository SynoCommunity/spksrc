SPK_NAME = firetv
SPK_VERS = 1.0.2
SPK_REV = 1
SPK_ICON = src/firetv.png
DEPENDS = cross/libusb
BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.6-8"
CHANGELOG = "Initial release"
BETA = 1
MAINTAINER = SynoCommunity
DESCRIPTION = Fire TV is a Python 2.x package that provides state information and some control of an Amazon Fire TV device over a network.
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = firetv

HOMEPAGE = https://github.com/happyleavesaoc/python-firetv
LICENSE  = MIT

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = firetv_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: firetv_extra_install
firetv_extra_install:
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/wheelhouse
	install -m 644 $(WORK_DIR)/wheelhouse/* $(STAGING_DIR)/share/wheelhouse/
