# Remember to also update jellyfin-web
SPK_NAME = jellyfin
SPK_VERS = 10.8.9
SPK_REV = 9
SPK_ICON = src/jellyfin.png
WIZARDS_DIR = src/wizard/
DSM_UI_DIR = app

DEPENDS = cross/libstdc++ cross/jellyfin cross/jellyfin-web

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS)
# custom exclusions for dotNET 6 on ARMv7 archs
include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
UNSUPPORTED_ARCHS += $(ARMv7_ARCHS)
else
UNSUPPORTED_ARCHS += armada370
endif

MAINTAINER = stevenliuit
DESCRIPTION = "The Free Software Media System. It is an alternative to the proprietary Emby and Plex."
DISPLAY_NAME = Jellyfin
STARTABLE = yes
CHANGELOG = "1. Update jellyfin to 10.8.9<br>2. Update dotnet 6.0.405"
HOMEPAGE = https://jellyfin.org
HELPURL = https://jellyfin.org/docs/general/server/settings.html
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

include ../../mk/spksrc.spk.mk
