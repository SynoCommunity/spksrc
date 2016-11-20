SPK_NAME = gogs
SPK_VERS = 0.97.7
SPK_REV = 0
SPK_ICON = src/gogs.png
DSM_UI_DIR = app

UNSUPPORTED_ARCHS = $(PPC_ARCHES)
DEPENDS  = cross/busybox cross/git cross/$(SPK_NAME)
#SPK_DEPENDS = "git>1.8.2"

MAINTAINER = torrentalle
DESCRIPTION = Go Git Service. A painless self-hosted Git service.

#DESCRIPTION_FRE = .
#ADMIN_PORT = 7070
#RELOAD_UI = yes
DISPLAY_NAME = Gogs
CHANGELOG = "Gogs v0.97.7"

HOMEPAGE   = https://gogs.io
LICENSE    = MIT

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf/


INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = gogs_extra_install

BUSYBOX_CONFIG = usrmng daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: gogs_extra_install
gogs_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/custom/conf
	install -m 600 src/app.ini ${STAGING_DIR}/var/custom/conf/app.ini
	install -m 755 -d $(STAGING_DIR)/var/logs
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
