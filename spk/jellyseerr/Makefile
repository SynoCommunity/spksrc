SPK_NAME = jellyseerr
SPK_VERS = 2.0.1
SPK_REV = 1
SPK_ICON = src/jellyseerr.png

DEPENDS = cross/jellyseerr

# x64 and armv8 archs are supported only.
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

MAINTAINER = SynoCommunity
MAINTAINER_URL = https://synocommunity.com/
DESCRIPTION = "Jellyseerr is a free and open source software application for managing requests for your media library."
CHANGELOG = "1. Initial release"
DISPLAY_NAME = Jellyseerr
HOMEPAGE = https://docs.jellyseerr.dev/
LICENSE = MIT
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/LICENSE
HELPURL = https://github.com/fallenbagel/jellyseerr/discussions

# Service configuration
STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 5055
SERVICE_PORT_TITLE = Jellyseerr (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

CONF_DIR = src/conf
WIZARDS_DIR = src/wizard/
DSM_UI_DIR = app

include ../../mk/spksrc.spk.mk
