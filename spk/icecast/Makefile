SPK_NAME = icecast
SPK_VERS = 2.4.4
SPK_REV = 6
SPK_ICON = src/icecast.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Icecast is a streaming media server which currently supports Ogg (Vorbis and Theora), Opus, WebM and MP3 audio streams. It can be used to create an Internet radio station or a privately running jukebox and many things in between. It is very versatile in that new formats can be added relatively easily and supports open standards for communication and interaction. This package includes Ezstream, a command line source client for Icecast media streaming servers.
ADMIN_PORT = 8000
CHANGELOG = "1. Security fixes for CVE-2018-10393, CVE-2017-14160, CVE-2018-10392 (libvorbis) and CVE-2021-22876, CVE-2021-22890 (libcurl).<br/>2. Adjust configuration for DSM7 compatibility.<br/>3. Update dependencies (taglib v1.12, vorbis v1.3.7, ezstream v1.0.2, libcurl v7.76.1)"

STARTABLE = yes
DISPLAY_NAME = Icecast

HOMEPAGE = https://www.icecast.org/
LICENSE = GPLv2

WIZARDS_DIR = src/wizards

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = icecast_extra_install

SPK_COMMANDS = bin/ezstream bin/ezstream-cfgmigrate bin/ezstream-file.sh

include ../../mk/spksrc.spk.mk

.PHONY: icecast_extra_install
icecast_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 644 src/icecast.xml $(STAGING_DIR)/var/icecast.xml
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
	# patch configuration paths for DSM 7
	sed -e 's|/var/packages/icecast/target/var|/var/packages/icecast/var|g' -i $(STAGING_DIR)/var/icecast.xml
endif
