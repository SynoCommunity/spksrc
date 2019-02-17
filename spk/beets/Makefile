SPK_NAME = beets
SPK_VERS = 1.4.7
SPK_REV = 3
SPK_ICON = src/beets.png

WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.8-11"

MAINTAINER = ymartin59
DESCRIPTION = "Beets is the media library management system for obsessive-compulsive music geeks. The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes. It then provides a bouquet of tools for manipulating and accessing your music. ReplayGain plugin is not available because of lacking dependencies."
DISPLAY_NAME = beets

CHANGELOG = "1. Upgrade to beets 1.4.7<br/>2. Include Chromaprint/Acoustid plugin, corresponding SynoCommunity package has to be installed if enabled."

HOMEPAGE   = http://beets.io/
LICENSE    = GPL

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk
