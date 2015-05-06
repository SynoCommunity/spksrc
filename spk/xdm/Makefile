SPK_NAME = xdm
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/xdm.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = lad1337
DISTRIBUTOR = Matr1x and Martijn de Vries
DESCRIPTION = XDM: eXtendable Download Manager. Plugin based media collection manager. XDM is a python based application that runs in the background and provides a Web-interface. It is highly extensable with plugins.
ADMIN_PORT =
RELOAD_UI = yes
DISPLAY_NAME = XDM
CHANGELOG = "1. Updated the package installer"

HOMEPAGE   = http://xdm.lad1337.de
LICENSE    =

WIZARDS_DIR = src/wizard/

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
	install -m 600 src/config.ini $(STAGING_DIR)/share/XDM/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/xdm.cgi $(STAGING_DIR)/app/xdm.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	mv $(STAGING_DIR)/share/XDM/* $(STAGING_DIR)
	rm -R $(STAGING_DIR)/share

$(STAGING_DIR)/share/XDM:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/lad1337/XDM.git
	rm -fr $(STAGING_DIR)/share/XDM/.git $(STAGING_DIR)/share/XDM/.gitignore