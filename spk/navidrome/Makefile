SPK_NAME = navidrome
SPK_VERS = 0.54.3
SPK_REV = 2
SPK_ICON = src/navidrome.png

DEPENDS = cross/navidrome

# C++11 compiler required
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)
# go does not support ppc archs
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

MAINTAINER = hgy59
HOMEPAGE = https://www.navidrome.org/
DESCRIPTION = 🎧☁ Modern Music Server and Streamer compatible with Subsonic/Airsonic. It gives you freedom to listen to your music collection from any browser or mobile device.
LICENSE = GPLv3
DISPLAY_NAME = Navidrome
CHANGELOG = "Update Navidrome to v0.54.3."

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
	install -d -m 755 $(STAGING_DIR)/var
	install -m 644 src/navidrome.toml $(STAGING_DIR)/var/
