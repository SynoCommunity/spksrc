SPK_NAME = bazarr

SPK_VERS = 1.2.1
SPK_REV = 9

SPK_ICON = src/bazarr.png

BUILD_DEPENDS = cross/python310

DEPENDS = cross/$(SPK_NAME)
DEPENDS += cross/libxml2 cross/libxslt
DEPENDS += cross/unrar

# [Pillow]
DEPENDS += cross/freetype cross/libjpeg cross/zlib
WHEELS_BUILD_ARGS += [Pillow]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --disable-platform-guessing
WHEELS_BUILD_ARGS += --enable-freetype
WHEELS_BUILD_ARGS += --enable-jpeg
WHEELS_BUILD_ARGS += --enable-zlib

SPK_DEPENDS = "python310:ffmpeg"

MAINTAINER = smaarn

DESCRIPTION = "Bazarr is a companion application to Sonarr and Radarr. It manages and downloads subtitles based on your requirements. You define your preferences by TV show or movies and Bazarr takes care of everything for you."
DISPLAY_NAME = Bazarr
STARTABLE = yes
CHANGELOG = "Update to version 1.2.1. <br />See corresponding changelogs <a href=\"https://github.com/morpheus65535/bazarr/releases/tag/v1.2.0\">here</a> and <a href=\"https://github.com/morpheus65535/bazarr/releases/tag/v1.2.1\">here</a> for more details."

HOMEPAGE = https://www.bazarr.media
LICENSE = GPLv3

SERVICE_USER  = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT  = 6767
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

# [numpy]
# gcc-4.6.4 failed with exit status 1
# https://github.com/numpy/numpy/issues/20664
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk.mk

# [numpy]
# Fix wheel building with older compilers
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CPPFLAGS = [numpy] -std=c++0x
# workaround for compiler bug:
# https://github.com/numpy/numpy/issues/13622
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
WHEELS_CFLAGS = [numpy] -O0
endif
endif
