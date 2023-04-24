# Remember to also update jellyfin-web
SPK_NAME = jellyfin
SPK_VERS = 10.8.10
SPK_REV = 10
SPK_ICON = src/jellyfin.png
WIZARDS_DIR = src/wizard/
DSM_UI_DIR = app

OPTIONAL_DEPENDS = cross/libstdc++
DEPENDS = cross/jellyfin cross/jellyfin-web

# x64 and armv8 archs are supported only.
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

MAINTAINER = stevenliuit
DESCRIPTION = "The Free Software Media System. It is an alternative to the proprietary Emby and Plex."
DISPLAY_NAME = Jellyfin
STARTABLE = yes
CHANGELOG = "1. Update jellyfin to 10.8.10<br/>2. Update dotnet to 6.0.16.<br/>3. Fix dotnet dependencies for DSM 7.2."
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

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# we do not only need the updated libstdc++ library, we also need to
# adjust the library search path for jellyfin to use this version.
DEPENDS += cross/libstdc++
POST_STRIP_TARGET = jellyfin_patch_target
endif

include ../../mk/spksrc.spk.mk

.PHONY: jellyfin_patch_target
# Set library path to use bundled libstdc++
jellyfin_patch_target:
	@$(MSG) "Set library runpath in jellyfin executable."
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/share/$(SPK_NAME)
