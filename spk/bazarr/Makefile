SPK_NAME = bazarr
SPK_VERS = 1.5.1
SPK_REV = 16
SPK_ICON = src/bazarr.png

PYTHON_PACKAGE = python312

SPK_DEPENDS = "python312:ffmpeg7"

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
CHANGELOG = '1. Update to 1.5.1. <br>See changelogs of <a href="https://github.com/morpheus65535/bazarr/releases/tag/v1.5.0">1.5.0</a> and <a href="https://github.com/morpheus65535/bazarr/releases/tag/v1.5.1">1.5.1</a> for more details. <br />2. Update to python 3.12'

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
WHEELS += src/requirements-crossenv-greenlet-v3.txt

# [numpy] >= 1.25.0 requires c++17 and 1.26 is required to support Python 3.12
WHEELS += src/requirements-crossenv-numpy.txt
