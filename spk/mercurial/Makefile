SPK_NAME = mercurial
SPK_VERS = 3.6.1
SPK_REV = 3
SPK_ICON = src/mercurial.png

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel cross/$(SPK_NAME)
WHEELS = $(SPK_NAME)==$(SPK_VERS)
SPK_DEPENDS = "python>=2.7.6-8"

MAINTAINER = SynoCommunity
DESCRIPTION = Mercurial is a free, distributed source control management tool
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Mercurial
CHANGELOG = Update to 3.6.1

HOMEPAGE = http://mercurial.selenic.com/
LICENSE  = MPL1.1

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = mercurial_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mercurial_extra_install
mercurial_extra_install:
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/wheelhouse
	install -m 644 $(WORK_DIR)/wheelhouse/* $(STAGING_DIR)/share/wheelhouse/
