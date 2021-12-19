SPK_NAME = bazarr

SPK_VERS = 1.0.2
SPK_REV = 3

SPK_ICON = src/bazarr.png

BUILD_DEPENDS = cross/python310

DEPENDS = cross/$(SPK_NAME)
DEPENDS += cross/unrar
DEPENDS += cross/numpy

SPK_DEPENDS = "python310:ffmpeg"

MAINTAINER = smaarn

DESCRIPTION = "Bazarr is a companion application to Sonarr and Radarr. It manages and downloads subtitles based on your requirements. You define your preferences by TV show or movies and Bazarr takes care of everything for you."
DISPLAY_NAME = Bazarr
STARTABLE = yes
CHANGELOG = "1. Several provider fixes + improved UI stability during heavy tasks<br/>2. Migration to Python 3.10"

HOMEPAGE = https://www.bazarr.media
LICENSE = GPLv3

SERVICE_USER  = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT  = 6767
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

include ../../mk/spksrc.spk.mk
