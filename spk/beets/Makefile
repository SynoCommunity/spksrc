SPK_NAME = beets
SPK_VERS = 2.2.0
SPK_REV = 10
SPK_ICON = src/beets.png

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE)"
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = ymartin59
DESCRIPTION = "Beets is the media library management system for obsessive-compulsive music geeks. The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes. It then provides a bouquet of tools for manipulating and accessing your music. Plugins not available due to lacking dependencies: AcousticBrainz Submit, Gmusic, ReplayGain."

DISPLAY_NAME = beets
STARTABLE = no
CHANGELOG = "1. Upgrade beets to 2.2.0.<br/>2. Migrate to Python 3.12.<br/>3. Update to all wheels."

HOMEPAGE = http://beets.io/
LICENSE  = GPL

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = env/bin/beet

include ../../mk/spksrc.python.mk

# NOTE: The following plugins were excluded due to being broken or deprecated:
# absubmit, docs, import, reflink

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [lxml] -std=c11
endif

# [Pillow]
DEPENDS += cross/pillow

# [PyYAML]
DEPENDS += cross/libyaml

# TODO: The following plugins are currently unsupported due to dependency issues:
# autobpm, bpd, metasync, and replaygain.

# [dbus_python]
#DEPENDS += cross/dbus					# expat not found!

# [llvmlite]
#DEPENDS += cross/llvm

# [msgpack]
#ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
#WHEELS_CFLAGS += [msgpack] -std=c11
#endif

# [pycairo]
#DEPENDS += cross/cairo					# Could not invoke sanity test executable
