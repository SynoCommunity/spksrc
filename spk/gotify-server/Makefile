SPK_NAME = gotify-server
SPK_VERS = 2.1.4
SPK_REV = 1
SPK_ICON = src/gotify-server.png

DEPENDS = cross/$(SPK_NAME)
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = SynoCommunity
DISPLAY_NAME = Gotify
DESCRIPTION = a simple server for sending and receiving messages
HOMEPAGE = https://gotify.net/
HELPURL = https://github.com/gotify/server/issues
LICENSE = MIT
CHANGELOG = "Initial release"

GROUP = synocommunity

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 7152
ADMIN_PORT = $(SERVICE_PORT)
SERVICE_PORT_TITLE = Gotify (HTTP)

include ../../mk/spksrc.spk.mk
