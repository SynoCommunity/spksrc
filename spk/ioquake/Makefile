SPK_NAME = ioquake
SPK_VERS = 3.0.0
SPK_REV = 1
SPK_ICON = src/quake3.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = DigitalBox
DESCRIPTION = Ioquake3 is a free software first person shooter engine based on the Quake 3: Arena and Quake 3: Team Arena. The source code is licensed under the GPL version 2, and was first released under that license by id software on August 20th, 2005. The goal is to create the open source Quake 3 distribution upon which people base their games, ports to new platforms, and other projects.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Quake III Server
CHANGELOG = "Initial version"

HOMEPAGE = https://ioquake3.org
LICENSE  = GPLv2

WIZARDS_DIR = WIZARD_UIFILES

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 27960
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
NO_SERVICE_SHORTCUT = yes
FWPORTS = src/ioquake.sc

POST_STRIP_TARGET = ioquake-post-strip

include ../../mk/spksrc.spk.mk

ioquake-post-strip:
	install -d $(STAGING_DIR)/var
	install -d $(STAGING_DIR)/baseq3
	install -d $(STAGING_DIR)/mission
	install -m 644 src/q3a/baseq3/pak1.pk3 $(STAGING_DIR)/baseq3/pak1.pk3
	install -m 644 src/q3a/baseq3/pak2.pk3 $(STAGING_DIR)/baseq3/pak2.pk3
	install -m 644 src/q3a/baseq3/pak3.pk3 $(STAGING_DIR)/baseq3/pak3.pk3
	install -m 644 src/q3a/baseq3/pak4.pk3 $(STAGING_DIR)/baseq3/pak4.pk3
	install -m 644 src/q3a/baseq3/pak5.pk3 $(STAGING_DIR)/baseq3/pak5.pk3
	install -m 644 src/q3a/baseq3/pak6.pk3 $(STAGING_DIR)/baseq3/pak6.pk3
	install -m 644 src/q3a/baseq3/pak7.pk3 $(STAGING_DIR)/baseq3/pak7.pk3
	install -m 644 src/q3a/baseq3/pak8.pk3 $(STAGING_DIR)/baseq3/pak8.pk3
	install -m 644 src/q3a/mission/pak1.pk3 $(STAGING_DIR)/mission/pak1.pk3
	install -m 644 src/q3a/mission/pak2.pk3 $(STAGING_DIR)/mission/pak2.pk3
	install -m 644 src/q3a/mission/pak3.pk3 $(STAGING_DIR)/mission/pak3.pk3
	install -m 644 src/q3a/baseq3/server.cfg $(STAGING_DIR)/baseq3/server.cfg
	install -m 644 src/q3a/baseq3/levels.cfg $(STAGING_DIR)/baseq3/levels.cfg
	install -m 644 src/q3a/baseq3/bots.cfg $(STAGING_DIR)/baseq3/bots.cfg
