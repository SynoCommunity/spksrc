SPK_NAME = beets
SPK_VERS = 1.6.0
SPK_REV = 7
SPK_ICON = src/beets.png

BUILD_DEPENDS = cross/python310

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt
SPK_DEPENDS = "python310>=3.10"

# Required for PyYAML
DEPENDS += cross/libyaml

# [Pillow]
DEPENDS += cross/freetype cross/libjpeg cross/zlib
WHEELS_BUILD_ARGS += [Pillow]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --disable-platform-guessing
WHEELS_BUILD_ARGS += --enable-freetype
WHEELS_BUILD_ARGS += --enable-jpeg
WHEELS_BUILD_ARGS += --enable-zlib

MAINTAINER = ymartin59
DESCRIPTION = "Beets is the media library management system for obsessive-compulsive music geeks. The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes. It then provides a bouquet of tools for manipulating and accessing your music. Plugins not available due to lacking dependencies: AcousticBrainz Submit, Gmusic, ReplayGain."
DISPLAY_NAME = beets

CHANGELOG = "1. Upgraded to 1.6.0</br>2. Updated minimum version of python to 3.10"

HOMEPAGE = http://beets.io/
LICENSE  = GPL

SERVICE_SETUP = src/service-setup.sh

STARTABLE = no

SPK_COMMANDS = env/bin/beet

include ../../mk/spksrc.spk.mk
