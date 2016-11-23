SPK_NAME = open-vm-tools
SPK_VERS = 10.0.7
SPK_REV = 1
SPK_ICON = src/open-vm-tools.png

REQUIRED_DSM = 6.0
BETA = 1

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = open-vm-tools is a set of services and modules that enable several features in VMware products for better management of, and seamless user interactions with, guests
RELOAD_UI = yes
DISPLAY_NAME = open-vm-tools

HOMEPAGE   = https://github.com/vmware/open-vm-tools
LICENSE    = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = myPostStrip

include ../../mk/spksrc.spk.mk

myPostStrip:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
			$(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
