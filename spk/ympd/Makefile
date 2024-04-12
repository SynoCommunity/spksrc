SPK_NAME = ympd
SPK_VERS = 1.3.0
SPK_REV = 2
SPK_ICON = src/ympd.png
DSM_UI_DIR = app

DEPENDS = cross/ympd

MAINTAINER = hgy59
DESCRIPTION = ympd: Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS.
CHANGELOG = "Fix service start for DSM 5 / SRM."

DISPLAY_NAME = MPD Web GUI

HOMEPAGE = https://ympd.org/
LICENSE = GPLv2

# SERVICE_COMMAND is defined in service-setup.sh
STARTABLE = yes
SERVICE_PORT = 8184
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = ympd_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: ympd_extra_install
ympd_extra_install:
	@$(MSG) Install service script
	@install -m 755 src/start.sh $(STAGING_DIR)/bin/
