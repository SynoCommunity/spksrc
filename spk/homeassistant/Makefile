SPK_NAME = homeassistant
SPK_VERS = 2024.12.5
SPK_REV = 24
SPK_ICON = src/homeassistant.png

HACS_VERS = 2.0.5

PYTHON_PACKAGE = python312
SPK_DEPENDS = $(PYTHON_PACKAGE)

# unsupported wheels: deebot_client, numpy, pymicro_vad, pyspeex_noise, and others
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

# mandatory wheel not available (av):
# It is possible to build for armv7, but av==13.1.0 is not available, and the
# basic system component 'anthemav' (aka. "Stream Domain") is not supported.
# For such builds the requirements-cross_from_index_armv7l.txt is still supported.
UNSUPPORTED_ARCHS += $(ARMv7_ARCHS)

MAINTAINER = hgy59
DESCRIPTION = "Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control."
DISPLAY_NAME = Home Assistant Core
CHANGELOG = "1. Update homeassistant to 2024.12.5 and depend on Python 3.12. <br/>2. Update HACS integration to v2.0.5. <br/><br/>REMARKS: Only arch specific python modules are included in the package. Other modules are downloaded at installation time."
STARTABLE = yes

HOMEPAGE = https://www.home-assistant.io/
LICENSE  = Apache-2.0

WIZARDS_DIR = src/wizard

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8123
SERVICE_PORT_TITLE = Home Assistant Core (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

USE_ALTERNATE_TMPDIR = 1

POST_STRIP_TARGET = homeassistant_extra_install

# Include cross compiled wheels only
# The package adds additional wheels from the index at installation time (requirements-cross_from_index.txt, requirements-pure.txt)
WHEELS = src/requirements-abi3.txt src/requirements-crossenv.txt

# python modules

# [Pillow]
DEPENDS += python/pillow_ha

# [DTLSSocket] runtime dependency of [tradfri]
DEPENDS += python/dtlssocket

# [numpy]
DEPENDS += python/numpy_ha

# definitions and libraries
# to build wheels of src/requirements-crossenv.txt and src/requirements-abi3.txt
# and runtime dependencies of pure python wheels
# ------------------------

# [voip_utils]
# for voice over ip integration
DEPENDS += cross/opus

# [gevent]
DEPENDS += cross/libev cross/c-ares
ENV += GEVENTSETUP_EMBED_CARES=FALSE
ENV += GEVENTSETUP_EMBED_LIBEV=FALSE

# [python-libnmap]
DEPENDS += cross/nmap

# [PyYAML]
DEPENDS += cross/libyaml

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [pycares]
DEPENDS += cross/c-ares
ENV += PYCARES_USE_SYSTEM_LIB=1

include ../../mk/spksrc.python.mk

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [pycryptodome] [pycryptodomex] [ciso8601]
WHEELS_CFLAGS += [pycryptodome] -std=c11
WHEELS_CFLAGS += [pycryptodomex] -std=c11
WHEELS_CFLAGS += [ciso8601] -std=c11

# use python arch specific requirements file to download cross wheels from index
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
REQUIREMENTS_FROM_INDEX = requirements-cross_from_index_x64.txt
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
REQUIREMENTS_FROM_INDEX = requirements-cross_from_index_aarch64.txt
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
REQUIREMENTS_FROM_INDEX = requirements-cross_from_index_i686.txt
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
REQUIREMENTS_FROM_INDEX = requirements-cross_from_index_armv7l.txt
endif

# target to download and prepare hacs after changing HACS_VERS above
# usage:
# make get_hacs
.PHONY: get_hacs
get_hacs:
	@$(MSG) Download HACS $(HACS_VERS) and create src/hacs.tar.gz
	@wget https://github.com/hacs/integration/releases/download/$(HACS_VERS)/hacs.zip
	@rm -rf hacs.tmp
	@mkdir hacs.tmp
	@unzip -d hacs.tmp hacs.zip
	@tar -czf src/hacs.tar.gz -C hacs.tmp .
	@rm -rf hacs.tmp

.PHONY: homeassistant_extra_install
homeassistant_extra_install:
	@install -m 755 -d $(STAGING_DIR)/share $(STAGING_DIR)/var
	@install -m 644 src/$(REQUIREMENTS_FROM_INDEX) $(STAGING_DIR)/share/requirements-cross_from_index.txt
	@install -m 644 src/requirements-pure.txt $(STAGING_DIR)/share/
	@install -m 644 src/hacs.tar.gz $(STAGING_DIR)/share/
	@install -m 644 src/requirements-custom.txt $(STAGING_DIR)/var/
