SPK_NAME = xdm
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/xdm.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = SynoCommunity
DESCRIPTION = XDM: eXtendable Download Manager. Plugin based media collection manager.
ADMIN_PORT = 8085
RELOAD_UI = yes
DISPLAY_NAME = XDM
BETA = 1

HOMEPAGE   = http://xdm.lad1337.de/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = xdm_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: xdm_extra_install
xdm_extra_install: $(STAGING_DIR)/share/XDM
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config

$(STAGING_DIR)/share/XDM:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone --depth=1 https://github.com/lad1337/XDM.git
