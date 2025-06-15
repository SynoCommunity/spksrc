# Remember to also update jellyfin-web
SPK_NAME = jellyfin
SPK_VERS = 10.10.7
SPK_REV = 26
SPK_ICON = src/jellyfin.png

OPTIONAL_DEPENDS = cross/libstdc++
DEPENDS = cross/jellyfin cross/jellyfin-web cross/libe_sqlite3

SPK_DEPENDS = "ffmpeg7"

# x64 and armv8 archs are supported only.
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = "The Free Software Media System. It is an alternative to the proprietary Emby and Plex."
DISPLAY_NAME = Jellyfin
CHANGELOG = "1. Update jellyfin to 10.10.7<br/>2. Built with dotnet 8.0.16 and nodejs 22.16.0"
HOMEPAGE = https://jellyfin.org
HELPURL = https://jellyfin.org/docs/general/server/settings.html
SUPPORTURL = https://jellyfin.org/docs/general/getting-help.html

LICENSE = GPLv2
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/LICENSE

WIZARDS_DIR = src/wizard/

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

DSM_UI_DIR = app
CONF_DIR = src/conf

# Service configuration
SERVICE_PORT = 8096
SERVICE_PORT_TITLE = Jellyfin (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = jellyfin_custom_libe_sqlite3

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# we do not only need the updated libstdc++ library, we also need to
# adjust the library search path for jellyfin to use this version.
DEPENDS += cross/libstdc++
POST_STRIP_TARGET += jellyfin_patch_target
endif

POST_STRIP_TARGET += jellyfin_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: jellyfin_custom_libe_sqlite3
jellyfin_custom_libe_sqlite3:
	@$(MSG) "Replace libe_sqlite3 with version built for DSM"
	mv -f $(STAGING_DIR)/lib/libe_sqlite3.so $(STAGING_DIR)/share/libe_sqlite3.so

.PHONY: jellyfin_patch_target
# Set library path to use bundled libstdc++
jellyfin_patch_target:
	@$(MSG) "Set library runpath in jellyfin executable."
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/share/$(SPK_NAME)

.PHONY: jellyfin_extra_install
jellyfin_extra_install:
	@$(MSG) "Install font configuration."
	@install -m 755 -d $(STAGING_DIR)/var/fonts
	@install -m 644 src/fonts/fonts.conf $(STAGING_DIR)/var/fonts/fonts.conf
