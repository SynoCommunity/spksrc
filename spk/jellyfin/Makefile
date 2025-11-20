# Remember to also update jellyfin-web
SPK_NAME = jellyfin
SPK_VERS = 10.11.3
SPK_REV = 31
SPK_ICON = src/jellyfin.png

DEPENDS = cross/jellyfin cross/jellyfin-web

# GLIBC >= 2.27 required
REQUIRED_MIN_DSM = 7.2
SPK_DEPENDS = "ffmpeg7"

# x64 and armv8 archs are supported only.
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = "The Free Software Media System. It is an alternative to the proprietary Emby and Plex."
DISPLAY_NAME = Jellyfin
CHANGELOG = "1. Update jellyfin to 10.11.3<br/>2. Built with dotnet 9.0.10 and nodejs 22.16.0"
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

# Use TMPDIR (insufficient space in /tmp/jellyfin)
USE_ALTERNATE_TMPDIR = 1

POST_STRIP_TARGET += jellyfin_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: jellyfin_extra_install
jellyfin_extra_install:
	@$(MSG) "Install font configuration."
	@install -m 755 -d $(STAGING_DIR)/var/fonts
	@install -m 644 src/fonts/fonts.conf $(STAGING_DIR)/var/fonts/fonts.conf
