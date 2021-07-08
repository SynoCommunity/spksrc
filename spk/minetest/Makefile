SPK_NAME = minetest
SPK_VERS = 0.4.17.1
SPK_REV = 1
SPK_ICON = src/minetest.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = toffee
DESCRIPTION = Minetest is an infinite-world block sandbox game and game engine. Players can create and destroy various types of blocks in a three-dimensional open world. This allows forming structures in every possible creation, on multiplayer servers or in singleplayer. Minetest is designed to be simple, stable, and portable. It is lightweight enough to run on fairly old hardware.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Minetest
CHANGELOG = "1. Initial version"

HOMEPAGE = https://www.minetest.net/
LICENSE  = GPLv2/GPLv3

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 30000
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
NO_SERVICE_SHORTCUT = yes
FWPORTS = src/minetest.sc

POST_STRIP_TARGET = minetest-post-strip

include ../../mk/spksrc.spk.mk

.PHONY: minetest-post-strip
minetest-post-strip:
	install -d $(STAGING_DIR)/var
	install -m 644 src/minetest.conf.example $(STAGING_DIR)/var/minetest.conf
