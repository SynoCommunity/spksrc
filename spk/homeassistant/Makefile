SPK_NAME = homeassistant
SPK_VERS = 2025.11.3
SPK_REV = 25
SPK_ICON = src/homeassistant.png

PYTHON_PACKAGE = python313
SPK_DEPENDS = $(PYTHON_PACKAGE)

# unsupported wheels: av, numpy; require glibc >= 2.28 (av), >= 2.27 (numpy)
REQUIRED_MIN_DSM = 7.2
REQUIRED_MIN_SRM = 1.3

# mandatory wheel not available (av):
UNSUPPORTED_ARCHS = $(ARMv7_ARCHS)

# REMARKS:
# Most of the wheels are downloaded and installed from the index at installation time,
# only cross compiled wheels that are not available in the index are included in the package.

MAINTAINER = hgy59
DESCRIPTION = Open source home automation that puts local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts. 
DISPLAY_NAME = Home Assistant Core
CHANGELOG = "1. Update homeassistant to 2025.11.3 and depend on Python 3.13. <br/><br/>REMARKS: A minimal set of cross compiled wheels is included in this package. All other wheels and HACS are downloaded at installation time. <br/>This is the last release that is officially supported. Home Assistand Core installation is deprecated since version 2025.12."
STARTABLE = yes

HOMEPAGE = https://www.home-assistant.io/
LICENSE = Apache 2.0

WIZARDS_DIR = src/wizard

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8123
SERVICE_PORT_TITLE = Home Assistant Core (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

USE_ALTERNATE_TMPDIR = 1

POST_STRIP_TARGET = homeassistant_extra_install

# To install HACS from downloaded zip
DEPENDS = cross/unzip

# Cross compiled wheels that are not available in the index
WHEELS = src/requirements-crossenv.txt

# [DTLSSocket] runtime dependency of [tradfri]
DEPENDS += python/dtlssocket

# [aiodhcpwatcher]
# runtime dependency: libpcap.so
# needs patch of scapy.py to find libpcap.so
DEPENDS += cross/libpcap

# [voip_utils]
# for voice over ip integration
# needs patch of opuslib to find libopus.so
DEPENDS += cross/opus

include ../../mk/spksrc.spk-python.mk

# use python arch specific requirements file to download cross wheels from index
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
REQUIREMENTS_FROM_INDEX = requirements-cross_from_index_x64.txt
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
REQUIREMENTS_FROM_INDEX = requirements-cross_from_index_aarch64.txt
endif

.PHONY: homeassistant_extra_install
homeassistant_extra_install:
	@install -m 755 -d $(STAGING_DIR)/share $(STAGING_DIR)/var
	@install -m 644 src/$(REQUIREMENTS_FROM_INDEX) $(STAGING_DIR)/share/requirements-cross_from_index.txt
	@install -m 644 src/requirements-pure.txt $(STAGING_DIR)/share/
	@install -m 644 src/requirements-integrations.txt $(STAGING_DIR)/share/
	@install -m 644 src/requirements-custom.txt $(STAGING_DIR)/var/
	@install -m 644 src/chunk.py $(STAGING_DIR)/share/
