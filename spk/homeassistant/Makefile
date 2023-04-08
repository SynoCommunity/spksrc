SPK_NAME = homeassistant
SPK_VERS = 2023.1.7
SPK_REV = 20
SPK_ICON = src/homeassistant.png

HACS_VERS = 1.31.0

SPK_DEPENDS = "python310"

BUILD_DEPENDS = cross/python310

# [numpy] > 1.22.4
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS) $(ARMv7L_ARCHS)

MAINTAINER = hgy59
DESCRIPTION = "Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control."
DISPLAY_NAME = Home Assistant Core
CHANGELOG = "1. Update homeassistant to 2023.1.7.<br/>2. Update HACS integration to v1.31.0.<br/><br/>REMARKS: Only arch specific python modules are included in the package. Other modules are downloaded at installation time."
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
WHEELS = src/requirements-abi3.txt src/requirements-crossenv.txt src/requirements-pure.txt

# cross wheels from source
# ------------------------
# those that do not build in crossenv (yet)

# [DTLSSocket] Required for postinst [tradfri]
DEPENDS += cross/dtlssocket


# definitions and libraries
# to build wheels of src/requirements-crossenv.txt
# ------------------------

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

# [Pillow]
DEPENDS += cross/freetype cross/libjpeg cross/zlib
WHEELS_BUILD_ARGS += [Pillow]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --disable-platform-guessing
WHEELS_BUILD_ARGS += --enable-freetype
WHEELS_BUILD_ARGS += --enable-jpeg
WHEELS_BUILD_ARGS += --enable-zlib

# [cryptography]
ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/

# [gevent]
DEPENDS += cross/libev cross/c-ares
ENV += GEVENTSETUP_EMBED_CARES=FALSE
ENV += GEVENTSETUP_EMBED_LIBEV=FALSE

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt


include ../../mk/spksrc.spk.mk

# prefere native python tools (pip, maturin, ...)
ENV += PATH=$(realpath $(WORK_DIR)/../../../native/python310/work-native/install/usr/local/bin):$(PATH)

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

# [pycryptodome] [pycryptodomex] [ciso8601]
ifeq ($(call version_ge, ${TC_GCC}, 4.9),1)
WHEELS_CFLAGS += [pycryptodome] -std=c11
WHEELS_CFLAGS += [pycryptodomex] -std=c11
WHEELS_CFLAGS += [ciso8601] -std=c11
else
WHEELS_CFLAGS += [pycryptodome] -std=c99
WHEELS_CFLAGS += [pycryptodomex] -std=c99
WHEELS_CFLAGS += [ciso8601] -std=c99
endif


# target to download and prepare hacs after changing HACS_VERS above
.PHONY: get_hacs
get_hacs:
	wget https://github.com/hacs/integration/releases/download/$(HACS_VERS)/hacs.zip
	rm -rf hacs.tmp
	mkdir hacs.tmp
	unzip -d hacs.tmp hacs.zip
	tar -czf src/hacs.tar.gz -C hacs.tmp .
	rm -rf hacs.tmp


.PHONY: homeassistant_extra_install
homeassistant_extra_install:
	@install -m 755 -d $(STAGING_DIR)/share $(STAGING_DIR)/var
	@install -m 644 src/postinst_components_requirements.txt $(STAGING_DIR)/share/
	@install -m 644 src/hacs.tar.gz $(STAGING_DIR)/share/
	@install -m 644 src/requirements-custom.txt $(STAGING_DIR)/var/requirements-custom.txt.new
