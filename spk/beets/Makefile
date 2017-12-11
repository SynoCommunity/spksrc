SPK_NAME = beets
SPK_VERS = 1.4.3
SPK_REV = 1
SPK_ICON = src/beets.png

WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.8-11"

MAINTAINER = Y.Martin
DESCRIPTION = "Beets is the media library management system for obsessive-compulsive music geeks. The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes. It then provides a bouquet of tools for manipulating and accessing your music. Chromaprint/Acoustid and ReplayGain plugins are not available because of lacking dependencies."
DISPLAY_NAME = beets
BETA = 1
CHANGELOG = "1. First package release"

HOMEPAGE   = http://beets.io/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk
