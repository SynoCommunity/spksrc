SPK_NAME = bazarr
SPK_VERS = 1.4.5
SPK_REV = 15
SPK_ICON = src/bazarr.png

PYTHON_PACKAGE = python311

SPK_DEPENDS = "python311:ffmpeg7"

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

DEPENDS = cross/bazarr
DEPENDS += cross/unrar

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [Pillow]
DEPENDS += cross/freetype cross/libjpeg cross/zlib
WHEELS_BUILD_ARGS += [Pillow]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --disable-platform-guessing
WHEELS_BUILD_ARGS += --enable-freetype
WHEELS_BUILD_ARGS += --enable-jpeg
WHEELS_BUILD_ARGS += --enable-zlib

MAINTAINER = smaarn
DESCRIPTION = "Bazarr is a companion application to Sonarr and Radarr. It manages and downloads subtitles based on your requirements. You define your preferences by TV show or movies and Bazarr takes care of everything for you."
DISPLAY_NAME = Bazarr
CHANGELOG = '1. Upgrade to ffmpeg 7 <br>2.Update to 1.4.5. <br>See changelogs of <a href="https://github.com/morpheus65535/bazarr/releases/tag/v1.4.5">1.4.5</a>, <a href="https://github.com/morpheus65535/bazarr/releases/tag/v1.4.4">1.4.4</a> and <a href="https://github.com/morpheus65535/bazarr/releases/tag/v1.4.3">1.4.3</a> for more details.'

HOMEPAGE  = https://www.bazarr.media/
LICENSE   = GPLv3
STARTABLE = yes

# [numpy] <= 1.21.6 (armv5)  - gcc-4.6.4 - unsupported
# [numpy] <= 1.22.4 (armv7l) - gcc-4.8.3 - unsupported
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

SERVICE_USER  = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT  = 6767
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.python.mk

# [greenlet]
ifeq ($(call version_ge, $(TC_GCC), 4.9),1)
WHEELS += src/requirements-crossenv-greenlet-v2.txt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CPPFLAGS += [greenlet] -std=c++11 -fpermissive
endif
else
WHEELS += src/requirements-crossenv-greenlet-v1.txt
endif

# [numpy] <= 1.24.4 last working version with gcc-4.9
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
WHEELS += src/requirements-crossenv-numpy-gcc4.txt
# [numpy] >= 1.25.0 requires c++17
else ifeq ($(call version_gt, $(TC_GCC), 5.0),1)
WHEELS += src/requirements-crossenv-numpy.txt
endif
# workaround for compiler bug:
# https://github.com/numpy/numpy/issues/13622
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
WHEELS_CFLAGS += [numpy] -O0
endif
endif
