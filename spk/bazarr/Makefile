SPK_NAME = bazarr

SPK_VERS = 1.0.0
SPK_REV = 1

SPK_ICON = src/bazarr.png

BUILD_DEPENDS = cross/python38

DEPENDS = cross/$(SPK_NAME)
DEPENDS += cross/unrar
DEPENDS += cross/numpy
DEPENDS += cross/webrtcvad
DEPENDS += cross/gevent
DEPENDS += cross/gevent-websocket
DEPENDS += cross/greenlet
DEPENDS += cross/zope.event

SPK_DEPENDS = "python38:ffmpeg"

MAINTAINER = smaarn

DESCRIPTION = "Bazarr is a companion application to Sonarr and Radarr. It manages and downloads subtitles based on your requirements. You define your preferences by TV show or movies and Bazarr takes care of everything for you."
DISPLAY_NAME = Bazarr
STARTABLE = yes
CHANGELOG = "Initial release"

HOMEPAGE = https://www.bazarr.media
LICENSE = GPLv3

SERVICE_USER  = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT  = 6767
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
