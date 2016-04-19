SPK_NAME = gogs
SPK_VERS = 0.9.13
SPK_REV = 1
SPK_ICON = src/gogs.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = Alexandre Espinosa Menor
DESCRIPTION = A painless self-hosted Git service.
ADMIN_URL = admin
ADMIN_PORT = 3000
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Gogs
CHANGELOG = First version

HOMEPAGE   = https://gogs.io
LICENSE    = MIT

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_DEP_SERVICES = mysql git
START_DEP_SERVICES = mysql git
INSTUNINST_RESTART_SERVICES = mysql git

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = gogs_extra_install


include ../../mk/spksrc.spk.mk

.PHONY: gogs_extra_install
gogs_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72 90 120 256; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
