SPK_NAME = owfs
SPK_VERS = 3.1p0
SPK_REV = 1
SPK_ICON = src/owfs.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = OWFS is an easy way to use the powerful 1-wire system of Dallas
STARTABLE = yes
DISPLAY_NAME = Owfs
CHANGELOG = "1. Initial release, just owserver and owhttp"

ADMIN_PORT = 2121
RELOAD_UI = yes

HOMEPAGE = http://owfs.org
LICENSE  = GPL-2.0+

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

WIZARDS_DIR      = src/wizard/

POST_STRIP_TARGET = owfs_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: owfs_extra_install
owfs_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/owfs.conf $(STAGING_DIR)/var/owfs.conf
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
