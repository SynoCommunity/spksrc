SPK_NAME = beets
SPK_VERS = 2.2.0
SPK_REV = 10
SPK_ICON = src/beets.png

PYTHON_PACKAGE = python311
SPK_DEPENDS = "python311>=3.11.5-8"
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = ymartin59
DESCRIPTION = "Beets is the media library management system for obsessive music geeks. The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes. It then provides a bouquet of tools for manipulating and accessing your music. Plugins not available due to lacking dependencies: AutoBPM, BPD, MetaSync, ReplayGain."

DISPLAY_NAME = beets
STARTABLE = no
CHANGELOG = "1. Upgrade beets to 2.2.0.<br/>2. Update to all wheels."

HOMEPAGE = http://beets.io/
LICENSE  = GPL

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = env/bin/beet

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [Pillow]
DEPENDS += python/pillow

# [PyYAML]
DEPENDS += cross/libyaml

# NOTE: Built with support for the following plugins:
# aura, beatport, chroma, discogs, embedart, embyupdate, fetchart, kodiupdate, lastgenre, lastimport, lyrics, mpdstats, plexupdate, scrub, sonosupdate, thumbnails, web.

# NOTE: The following plugins are currently unsupported due to dependency issues:
# autobpm, bpd, metasync, and replaygain.

include ../../mk/spksrc.python.mk
