SPK_NAME = htpcmanager
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 2
SPK_ICON = src/htpcmanager.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3:git"


MAINTAINER = SynoCommunity
DESCRIPTION = Control your Htpc with ease. Using multiple applications to control you htpc? No More! Htpc Manager combines all your software and provides an easy way to controll them all!
ADMIN_PORT = 8087
RELOAD_UI = yes
DISPLAY_NAME = HTPC-Manager

HOMEPAGE   = http://htpc.io

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/
WIZARDS_DIR      = src/wizard/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
COPY_TARGET = nop

POST_STRIP_TARGET = htpcmanager_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: htpcmanager_extra_install
htpcmanager_extra_install: 
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
