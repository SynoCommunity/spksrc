SPK_NAME = mercurial
SPK_VERS = 2.8.2
SPK_REV = 1
SPK_ICON = src/mercurial.png
DSM_UI_DIR = app

DEPENDS = 
WHEELS = mercurial==$(SPK_VERS)
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = SynoCommunity
DESCRIPTION = Mercurial is a free, distributed source control management tool
RELOAD_UI = yes
DISPLAY_NAME = Mercurial
BETA = 1

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
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/wheelhouse
	install -m 644 $(WORK_DIR)/wheelhouse/* $(STAGING_DIR)/share/wheelhouse/
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
			$(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
