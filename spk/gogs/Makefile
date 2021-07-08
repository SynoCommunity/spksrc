SPK_NAME = gogs
SPK_VERS = 0.97.7
SPK_REV = 1
SPK_ICON = src/gogs.png
DSM_UI_DIR = app

BETA = 1

UNSUPPORTED_ARCHS = $(PPC_ARCHES)
DEPENDS  = cross/busybox cross/git cross/$(SPK_NAME)

MAINTAINER = torrentalle
DESCRIPTION = "Gogs lets you host your own private Git repositories on your own servers. It's a very detailed clone of GitHub, both in design and features. It's built in Go and works really, really fast!"

ADMIN_PORT = 3000
RELOAD_UI = yes
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
