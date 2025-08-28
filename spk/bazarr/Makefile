SPK_NAME = bazarr
SPK_VERS = 1.5.2
SPK_REV = 17
SPK_ICON = src/bazarr.png

PYTHON_PACKAGE = python312

SPK_DEPENDS = "${PYTHON_PACKAGE}:ffmpeg7"

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

DEPENDS = cross/bazarr
DEPENDS += cross/unrar

MAINTAINER = smaarn
DESCRIPTION = "Bazarr is a companion application to Sonarr and Radarr. It manages and downloads subtitles based on your requirements. You define your preferences by TV show or movies and Bazarr takes care of everything for you."
DISPLAY_NAME = Bazarr
CHANGELOG = '1. Update bazarr to 1.5.2. <br/>See changelogs of <a href="https://github.com/morpheus65535/bazarr/releases/tag/v1.5.2">1.5.2</a> for more details.'

HOMEPAGE  = https://www.bazarr.media/
LICENSE   = GPLv3
STARTABLE = yes

# [numpy]
# Requires gcc>=8.4 to build succesfully
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

SERVICE_USER  = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT  = 6767
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
USE_ALTERNATE_TMPDIR = 1

# [Pillow]
DEPENDS += python/pillow

include ../../mk/spksrc.python.mk

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [lxml] -std=c11
endif

# [numpy]
# gcc-8.4 is the minimal version to build numpy
# gcc-8.5 hapens to be the default version for DSM-7.1
ifeq ($(call version_gt, $(TC_GCC), 8.4),1)
DEPENDS += python/numpy
endif
