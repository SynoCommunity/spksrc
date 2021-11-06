SPK_NAME = filebrowser
SPK_VERS = 2.18.0
SPK_REV = 2
SPK_ICON = src/filebrowser.png

DEPENDS = cross/$(SPK_NAME)
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = publicarray
DESCRIPTION = Web File Browser
DISPLAY_NAME = File Browser
HELPURL = https://github.com/filebrowser/filebrowser/issues
LICENSE = Apache-2.0
CHANGELOG = "First Version"

GROUP = synocommunity

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8091
ADMIN_PORT = $(SERVICE_PORT)
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

include ../../mk/spksrc.spk.mk
