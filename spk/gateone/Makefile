SPK_NAME = gateone
SPK_VERS = 20151116
SPK_REV = 6
SPK_ICON = src/gateone.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/dtach cross/$(SPK_NAME)
WHEELS = certifi backports.ssl-match-hostname tornado html5lib
SPK_DEPENDS = "python>=2.7.6-8"

MAINTAINER = Diaoul
DESCRIPTION = Gate One is an HTML5-powered terminal emulator and SSH client
DESCRIPTION_FRE = Gate One est un émulateur de terminal et un client SSH fonctionnant en HTML5
ADMIN_PROTOCOL = https
ADMIN_PORT = 8271
RELOAD_UI = yes
DISPLAY_NAME = GateOne
CHANGELOG = "Update to revision 1d0e803"

HOMEPAGE   = http://liftoffsoftware.com/Products/GateOne
LICENSE    = AGPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = gateone_extra_install

BUSYBOX_CONFIG  = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: gateone_extra_install
gateone_extra_install:
	install -m 755 -d ${STAGING_DIR}/share/wheelhouse
	install -m 644 ${WORK_DIR}/wheelhouse/* ${STAGING_DIR}/share/wheelhouse/
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/ssl
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/conf.d
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/90custom.conf $(STAGING_DIR)/var/conf.d/
	install -m 644 src/95users.conf $(STAGING_DIR)/var/conf.d/
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
