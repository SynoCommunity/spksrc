SPK_NAME = jellyfin
SPK_VERS = 10.7.0
SPK_REV = 1
SPK_ICON = src/jellyfin.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME) cross/$(SPK_NAME)-web

MAINTAINER = publicarray
DESCRIPTION = "The Free Software Media System. It is an alternative to the proprietary Emby and Plex."
DISPLAY_NAME = Jellyfin
BETA = 1
STARTABLE = yes
CHANGELOG = "First version"
HOMEPAGE = https://jellyfin.org
LICENSE = GPLv2

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# Service configuration
SERVICE_PORT = 8096
SERVICE_PORT_TITLE = Jellyfin (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(i686_ARCHS) $(ARMv7L_ARCHS)

include ../../mk/spksrc.spk.mk
