SPK_NAME = beets
SPK_VERS = 2.3.1
SPK_REV = 11
SPK_ICON = src/beets.png

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE)"

# numpy, pygobject
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = ymartin59
DESCRIPTION = Beets is the media library management system for obsessive music geeks. The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes. It then provides a bouquet of tools for manipulating and accessing your music.

DISPLAY_NAME = beets
STARTABLE = no
CHANGELOG = "1. Update beets to 2.3.1.<br/>2. Migrate to Python 3.12."

HOMEPAGE = http://beets.io/
LICENSE  = GPL

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = env/bin/beet
SPK_COMMANDS += bin/mp3gain

# NOTE: Built with support for the following plugins:
# beatport, chroma, discogs, embedart, embyupdate, fetchart, kodiupdate, lastgenre, lastimport, lyrics, metasync, plexupdate, replaygain, scrub, sonosupdate.

# NOTE: Plugins not available due to lacking dependencies: AutoBPM.

### dependencies for plugins:
### -------------------------

### plugin: metasync
# [dbus-python]
DEPENDS += python/dbus-python

### plugin: sonosupdate
# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

### plugins: embedart, fetchart
# [Pillow]
DEPENDS += python/pillow

### plugin: replaygain
# [pycairo]
DEPENDS += python/pycairo

# [pygobject] - depends on [pycairo]
DEPENDS += python/pygobject

### plugin: replaygain
DEPENDS += cross/mp3gain

### -------------------------

# [PyYAML]
DEPENDS += cross/libyaml

# [numpy]
DEPENDS += python/numpy

# [lap] - depends on [numpy]
DEPENDS += python/lap

include ../../mk/spksrc.python.mk
