SPK_NAME = beets
SPK_VERS = 1.4.9
SPK_REV = 5
SPK_ICON = src/beets.png

PIP = $(WORK_DIR)/../../../native/python3/work-native/install/usr/local/bin/pip
BUILD_DEPENDS = native/python3

WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.7.7"

MAINTAINER = ymartin59
DESCRIPTION = "Beets is the media library management system for obsessive-compulsive music geeks. The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes. It then provides a bouquet of tools for manipulating and accessing your music. Plugins not available due to lacking dependencies: AcousticBrainz Submit, Gmusic, ReplayGain."
DISPLAY_NAME = beets

CHANGELOG = "1. Upgraded minimum version of python 3."

HOMEPAGE = http://beets.io/
LICENSE  = GPL

SERVICE_SETUP = src/service-setup.sh

STARTABLE = no

SPK_USR_LOCAL_LINKS = bin:env/bin/beet

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk
