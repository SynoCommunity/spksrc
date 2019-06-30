SPK_NAME = hass.io
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = alpha
SPK_ICON = src/hass.png
DSM_UI_DIR = app

SPK_DEPENDS = "Docker"

MAINTAINER = fredrike+hassio@gmail.com
DESCRIPTION = Open source home automation that puts local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts.
ADMIN_PORT = $(SERVICE_PORT)
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Hass.io 
CHANGELOG = ""

HOMEPAGE   = https://www.home-assistant.io/hassio/
LICENSE    = Apache License 2.0
HELPURL    = https://www.home-assistant.io/docs/

WIZARDS_DIR = src/wizard/

SERVICE_SETUP = src/service-setup.sh
SSS_SCRIPT = src/start-stop-status
FWPORTS = src/${SPK_NAME}.sc
# CONF_DIR         = src/conf/
# SERVICE_PORT = 8126
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

INSTALL_DEP_SERVICES = Docker 
START_DEP_SERVICES = Docker

COPY_TARGET = nop

POST_STRIP_TARGET = hassio_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: hassio_extra_install
hassio_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/hassio.json $(STAGING_DIR)/var/hassio.json