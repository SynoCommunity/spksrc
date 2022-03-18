SPK_NAME = homeassistant
SPK_VERS = 2021.9.7
SPK_REV = 17
SPK_ICON = src/${SPK_NAME}.png

SPK_DEPENDS = "python310"

BUILD_DEPENDS = cross/python310

MAINTAINER = hgy59
DESCRIPTION = "Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control."
DISPLAY_NAME = Home Assistant Core
CHANGELOG = "Update homeassistant to 2021.9.7.<br/>Only arch specific python modules are included in the package. Other modules are downloaded at installation time."
STARTABLE = yes

HOMEPAGE = https://www.home-assistant.io/
LICENSE  = Apache-2.0

WIZARDS_DIR = src/wizard

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8123
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
ADMIN_PORT = $(SERVICE_PORT)

USE_ALTERNATE_TMPDIR = 1

POST_STRIP_TARGET = homeassistant_extra_install

# Include cross compiled wheels only, the package installer downloads pure python wheels at installation time.
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt src/requirements-abi3.txt

# [gevent]
DEPENDS += cross/libev cross/c-ares
ENV += GEVENTSETUP_EMBED_CARES=FALSE
ENV += GEVENTSETUP_EMBED_LIBEV=FALSE

# [python-libnmap]
DEPENDS += cross/nmap

# [DTLSSocket] Required for postinst [tradfri]
DEPENDS += cross/dtlssocket

# [PyYAML]
DEPENDS += cross/libyaml

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [pycares]
DEPENDS += cross/c-ares
ENV += PYCARES_USE_SYSTEM_LIB=1

# [Pillow]
DEPENDS += cross/freetype cross/libjpeg cross/zlib
WHEELS_BUILD_ARGS += [Pillow]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --disable-platform-guessing
WHEELS_BUILD_ARGS += --enable-freetype
WHEELS_BUILD_ARGS += --enable-jpeg
WHEELS_BUILD_ARGS += --enable-zlib

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

.PHONY: homeassistant_extra_install
homeassistant_extra_install:
	@install -m 755 -d $(STAGING_DIR)/share
	@install -m 644 src/postinst_default_config_requirements.txt $(STAGING_DIR)/share/
	@install -m 644 src/postinst_components_requirements.txt $(STAGING_DIR)/share/
