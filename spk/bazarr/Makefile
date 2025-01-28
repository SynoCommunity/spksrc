SPK_NAME = bazarr
SPK_VERS = 1.5.1
SPK_REV = 16
SPK_ICON = src/bazarr.png

PYTHON_PACKAGE = python311

SPK_DEPENDS = "${PYTHON_PACKAGE}:ffmpeg7"

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

DEPENDS = cross/bazarr
DEPENDS += cross/unrar

MAINTAINER = smaarn
DESCRIPTION = "Bazarr is a companion application to Sonarr and Radarr. It manages and downloads subtitles based on your requirements. You define your preferences by TV show or movies and Bazarr takes care of everything for you."
DISPLAY_NAME = Bazarr
CHANGELOG = '1. Update bazarr to 1.5.1. <br/>See changelogs of <a href="https://github.com/morpheus65535/bazarr/releases/tag/v1.5.1">1.5.1</a> and <a href="https://github.com/morpheus65535/bazarr/releases/tag/v1.5.0">1.5.0</a> for more details.'

HOMEPAGE  = https://www.bazarr.media/
LICENSE   = GPLv3
STARTABLE = yes

# [numpy] <= 1.21.6 (armv5)
# This version is now unsupported using py311
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)

SERVICE_USER  = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT  = 6767
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
USE_ALTERNATE_TMPDIR = 1

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [Pillow]
DEPENDS += cross/pillow

include ../../mk/spksrc.python.mk

# [numpy] <= 1.22.4 (armv7l)
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
WHEELS += src/requirements-crossenv-numpy-armv7l.txt
# [numpy] <= 1.24.4 last working version with gcc-4.9
else
WHEELS += src/requirements-crossenv-numpy-gcc4.txt
endif

# workaround for compiler bug:
# https://github.com/numpy/numpy/issues/13622
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
WHEELS_CFLAGS += [numpy] -O0
endif
endif
