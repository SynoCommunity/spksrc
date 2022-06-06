SPK_NAME = ympd
SPK_VERS = 1.3.0
SPK_REV = 1
SPK_ICON = src/ympd.png
DSM_UI_DIR = app

DEPENDS = cross/ympd

MAINTAINER = hgy59
DESCRIPTION = ympd: Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS.
CHANGELOG = "Initial package release."

DISPLAY_NAME = MPD Web GUI

HOMEPAGE = https://ympd.org/
LICENSE = GPLv2

# SERVICE_COMMAND is defined in service-setup.sh
STARTABLE = yes
SERVICE_PORT = 8184
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
