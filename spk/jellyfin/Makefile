# Remember to also update jellyfin-web
SPK_NAME = jellyfin
SPK_VERS = 10.7.6
SPK_REV = 3
SPK_ICON = src/jellyfin.png
WIZARDS_DIR = src/wizard/
DSM_UI_DIR = app

DEPENDS = cross/libstdc++ cross/$(SPK_NAME) cross/$(SPK_NAME)-web

MAINTAINER = publicarray
DESCRIPTION = "The Free Software Media System. It is an alternative to the proprietary Emby and Plex."
DISPLAY_NAME = Jellyfin
STARTABLE = yes
CHANGELOG = "Update jellyfin to 10.7.6"
HOMEPAGE = https://jellyfin.org
HELPURL    = https://jellyfin.org/docs/general/server/settings.html
SUPPORTURL = https://jellyfin.org/docs/general/getting-help.html
LICENSE = GPLv2
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/LICENSE
SPK_DEPENDS = "ffmpeg>=4.2"

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

CONF_DIR = src/conf

# Service configuration
SERVICE_PORT = 8096
SERVICE_PORT_TITLE = Jellyfin (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(i686_ARCHS) $(ARMv7L_ARCHS)

include ../../mk/spksrc.spk.mk
