SPK_NAME = ntopng
SPK_VERS = 2.4.2
SPK_REV = 3
SPK_ICON = src/ntopng.png
DSM_UI_DIR = app
CHANGELOG = 

BETA = 1

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = ntopng is the next generation version of the original ntop, a network traffic probe that shows the network usage, similar to what the popular top Unix command does.
RELOAD_UI = yes
DISPLAY_NAME = ntopng
ADMIN_PORT = 3000
STARTABLE = yes

HOMEPAGE = http://www.ntop.org/
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =
FWPORTS = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = ntop_extra_install


include ../../mk/spksrc.spk.mk

.PHONY: ntop_extra_install
ntop_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/ntopng.conf $(STAGING_DIR)/var/ntopng.conf
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
