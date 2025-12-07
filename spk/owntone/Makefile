SPK_NAME = owntone
SPK_VERS = 29.0
SPK_REV = 1
SPK_ICON = src/owntone.png

FFMPEG_PACKAGE = ffmpeg7
DEPENDS = cross/owntone
SPK_DEPENDS = $(FFMPEG_PACKAGE)

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS) $(i686_ARCHS) comcerto2k


MAINTAINER = SynoCommunity
# TODO: add limitations to DESCRIPTION
# - mdns does not work under DSM
# - 
DESCRIPTION = OwnTone is an open source \(audio\) media server. It allows sharing and streaming your media library to iTunes \(DAAP1\), Roku \(RSP\), AirPlay devices \(multi-room\), Chromecast and also supports local playback.
CHANGELOG = "Initial package release."

DISPLAY_NAME = OwnTone

HOMEPAGE = http://owntone.github.io/owntone-server
LICENSE  = GPLv2

# owntone's ports
# 3689	(daap)
# 3688	(web UI)
# 6600	(MPD client requests)

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes
SERVICE_PORT = 3689
ADMIN_PORT = $(SERIVCE_PORT)

POST_STRIP_TARGET = owntone_extra_install

include ../../mk/spksrc.ffmpeg.mk

.PHONY: owntone_extra_install
owntone_extra_install:
	install -d -m 755 $(STAGING_DIR)/var
	install -m 644 src/owntone.conf $(STAGING_DIR)/var
