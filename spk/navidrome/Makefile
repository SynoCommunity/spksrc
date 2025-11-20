SPK_NAME = navidrome
SPK_VERS = 0.56.1
SPK_REV = 5
SPK_ICON = src/navidrome.png

DEPENDS = cross/navidrome

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

MAINTAINER = hgy59
HOMEPAGE = https://www.navidrome.org/
DESCRIPTION = 🎧☁ Modern Music Server and Streamer compatible with Subsonic/Airsonic. It gives you freedom to listen to your music collection from any browser or mobile device.
LICENSE = GPLv3
DISPLAY_NAME = Navidrome
CHANGELOG = "Update Navidrome to v0.56.1 (requires DSM 7+)."

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

SERVICE_USER = auto
SERVICE_PORT = 4533
SERVICE_PORT_TITLE = Navidrome (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard
SERVICE_WIZARD_SHARENAME = wizard_music_folder

POST_STRIP_TARGET = navidrome_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: navidrome_extra_install
navidrome_extra_install:
	@$(MSG) Install navidrome.toml
	@install -d -m 755 $(STAGING_DIR)/var
	@install -m 644 src/navidrome.toml $(STAGING_DIR)/var/
