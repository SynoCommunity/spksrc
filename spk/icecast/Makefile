SPK_NAME = icecast
SPK_VERS = 2.4.4
SPK_REV = 7
SPK_ICON = src/icecast.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Icecast is a streaming media server which currently supports Ogg \(Vorbis and Theora\), Opus, WebM and MP3 audio streams. It can be used to create an Internet radio station or a privately running jukebox and many things in between. It is very versatile in that new formats can be added relatively easily and supports open standards for communication and interaction. This package includes Ezstream, a command line source client for Icecast media streaming servers.
CHANGELOG = "1. Update openssl to v1.1.1p.<br/>2. Update to libcurl of curl v7.83.1."
DISPLAY_NAME = Icecast2

HOMEPAGE = https://www.icecast.org/
LICENSE = GPLv2

WIZARDS_DIR = src/wizards

SERVICE_PORT = 8000
ADMIN_PORT = $(SERVICE_PORT)
SERVICE_URL = /admin/
SERVICE_USER = auto
# SERVICE_COMMAND is defined in service-setup.sh
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = icecast_extra_install

SPK_COMMANDS = bin/ezstream bin/ezstream-cfgmigrate bin/ezstream-file.sh

include ../../mk/spksrc.spk.mk

.PHONY: icecast_extra_install
icecast_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 644 src/icecast.xml $(STAGING_DIR)/var/icecast.xml
	install -m 644 src/mime.types  $(STAGING_DIR)/var/mime.types
