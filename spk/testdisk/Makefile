SPK_NAME = testdisk
SPK_VERS = 7.0
SPK_REV = 1
SPK_ICON = src/testdisk.png

DEPENDS  = cross/$(SPK_NAME)

RELOAD_UI = yes
STARTABLE = no
BETA = 1

MAINTAINER = SynoCommunity
DESCRIPTION = "TestDisk is powerful free data recovery software"
DISPLAY_NAME = TestDisk

HOMEPAGE   = http://www.cgsecurity.org/wiki/TestDisk
LICENSE    = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = testdisk_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: testdisk_extra_install
testdisk_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
