# Remember to also update jellyfin-web
SPK_NAME = jellyfin
SPK_VERS = 10.9.6
SPK_REV = 14
SPK_ICON = src/jellyfin.png
WIZARDS_DIR = src/wizard/
DSM_UI_DIR = app

DEPENDS = cross/jellyfin cross/jellyfin-web

# GLIBC >= 2.28 required
REQUIRED_MIN_DSM = 7.2

# x64 and armv8 archs are supported only.
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

MAINTAINER = stevenliuit
DESCRIPTION = "The Free Software Media System. It is an alternative to the proprietary Emby and Plex."
DISPLAY_NAME = Jellyfin
STARTABLE = yes
CHANGELOG = "Update jellyfin to 10.9.6<br/>Built with dotnet 8 and nodejs 20."
HOMEPAGE = https://jellyfin.org
HELPURL = https://jellyfin.org/docs/general/server/settings.html
SUPPORTURL = https://jellyfin.org/docs/general/getting-help.html
LICENSE = GPLv2
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/LICENSE
SPK_DEPENDS = "ffmpeg6"

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

CONF_DIR = src/conf

# Service configuration
SERVICE_PORT = 8096
SERVICE_PORT_TITLE = Jellyfin (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
