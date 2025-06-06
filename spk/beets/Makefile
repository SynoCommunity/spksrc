SPK_NAME = beets
SPK_VERS = 2.3.1
SPK_REV = 11
SPK_ICON = src/beets.png

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE)"

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = ymartin59
DESCRIPTION = "Beets is the media library management system for obsessive music geeks. The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes. It then provides a bouquet of tools for manipulating and accessing your music. Plugins not available due to lacking dependencies: AutoBPM."

DISPLAY_NAME = beets
STARTABLE = no
CHANGELOG = "1. Update beets to 2.3.1.<br/>2. Migrate to Python 3.12."

HOMEPAGE = http://beets.io/
LICENSE  = GPL

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = env/bin/beet

# NOTE: Built with support for the following plugins:
# aura, beatport, chroma, discogs, embedart, embyupdate, fetchart, kodiupdate, lastgenre, lastimport, lyrics, mpdstats, plexupdate, scrub, sonosupdate, thumbnails, web.

# [dbus-python]
DEPENDS += python/dbus-python

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [Pillow]
DEPENDS += python/pillow

# [pycairo]
DEPENDS += python/pycairo

# [PyYAML]
DEPENDS += cross/libyaml

# [numpy]
# gcc-8.4 is the minimal version to build numpy
# gcc-8.5 happens to be the default version for DSM-7.1
DEPENDS += python/numpy

# [lap] - depends on [numpy]
DEPENDS += python/lap

include ../../mk/spksrc.python.mk

# TODO: The following plugins are currently unsupported due to dependency issues:
# bpd, metasync, and replaygain.

# [dbus_python]
#DEPENDS += cross/dbus					# expat not found!
