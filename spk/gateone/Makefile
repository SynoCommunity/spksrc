SPK_NAME = gateone
SPK_VERS = 20171125
SPK_REV = 8
SPK_ICON = src/gateone.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/dtach cross/$(SPK_NAME)
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.11-15"

MAINTAINER = M4tt075
DESCRIPTION = Gate One is an HTML5-powered terminal emulator and SSH client
DESCRIPTION_FRE = Gate One est un émulateur de terminal et un client SSH fonctionnant en HTML5
RELOAD_UI = yes
DISPLAY_NAME = GateOne
STARTABLE = yes
CHANGELOG = "1. Update Gateone to revision 6ae1d01, 2. Update dtach to v0.9, 3. Use DSM 5+6 service approach."
HOMEPAGE = http://liftoffsoftware.com/Products/GateOne
LICENSE = AGPLv3

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# Service configuration
SERVICE_PORT = 8271
SERVICE_PORT_PROTOCOL = https
SERVICE_PORT_TITLE = Gateone (HTTPS)

# Admin link
ADMIN_PROTOCOL = https
ADMIN_PORT = ${SERVICE_PORT}

POST_STRIP_TARGET = gateone_extra_install

BUSYBOX_CONFIG  = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: gateone_extra_install
gateone_extra_install:
	install -m 755 -d $(STAGING_DIR)/ssl
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/conf.d
	install -m 644 src/90custom.conf $(STAGING_DIR)/var/conf.d/
	install -m 644 src/95users.conf $(STAGING_DIR)/var/conf.d/
