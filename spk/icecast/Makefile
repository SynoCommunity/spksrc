SPK_NAME = icecast
SPK_VERS = 2.4.4
SPK_REV = 5
SPK_ICON = src/icecast.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = "Icecast is a streaming media server which currently supports Ogg \(Vorbis and Theora\), Opus, WebM and MP3 audio streams. It can be used to create an Internet radio station or a privately running jukebox and many things in between. It is very versatile in that new formats can be added relatively easily and supports open standards for communication and interaction. This package includes Ezstream, a command line source client for Icecast media streaming servers."
ADMIN_PORT = 8000
CHANGELOG = "Update openssl to 1.1."

RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Icecast

HOMEPAGE   = https://www.icecast.org/
LICENSE    = GPLv2

WIZARDS_DIR = WIZARD_UIFILES

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = icecast_extra_install

BUSYBOX_CONFIG = usrmng daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"


include ../../mk/spksrc.spk.mk

.PHONY: icecast_extra_install
icecast_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 644 src/icecast.xml $(STAGING_DIR)/var/icecast.xml
