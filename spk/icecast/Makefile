SPK_NAME = icecast
SPK_VERS = 2.4.1
SPK_REV = 1
SPK_ICON = src/icecast.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = "Icecast is a streaming media server which currently supports Ogg \(Vorbis and Theora\), Opus, WebM and MP3 audio streams. It can be used to create an Internet radio station or a privately running jukebox and many things in between. It is very versatile in that new formats can be added relatively easily and supports open standards for communication and interaction."
ADMIN_PORT = 8000

RELOAD_UI = yes
DISPLAY_NAME = icecast

HOMEPAGE   = http://www.icecast.org/
LICENSE    = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = icecast_extra_install

BUSYBOX_CONFIG = usrmng daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: icecast_extra_install
icecast_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 644 src/icecast.xml $(STAGING_DIR)/var/icecast.xml
