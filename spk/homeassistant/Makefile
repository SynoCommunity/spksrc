SPK_NAME = homeassistant
SPK_VERS = 2023.7.3
SPK_REV = 22
SPK_ICON = src/homeassistant.png

HACS_VERS = 1.32.1

PYTHON_PACKAGE = python311
SPK_DEPENDS = "$(PYTHON_PACKAGE)>=3.11.4-7"

OPTIONAL_DEPENDS = cross/libstdc++

# [numpy] > 1.22.4
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS) $(ARMv7L_ARCHS)

MAINTAINER = hgy59
DESCRIPTION = "Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control."
DISPLAY_NAME = Home Assistant Core
CHANGELOG = "1. Update homeassistant to 2023.7.3. and depend on Python 3.11 and OpenSSL 3.1.<br/>2. Update HACS integration to v1.32.1.<br/>3. Add libstdc++ for DSM 6 to fix grpcio dependency.<br/><br/>REMARKS: Only arch specific python modules are included in the package. Other modules are downloaded at installation time."
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

# Include cross compiled wheels only, the package installer downloads pure python wheels at installation time.
WHEELS = src/requirements-abi3.txt src/requirements-crossenv.txt src/requirements-pure.txt

# [DTLSSocket] runtime dependency of [tradfri]
DEPENDS += cross/dtlssocket

include ../../mk/spksrc.common.mk

# [grpcio]
# for DSM < 7 with too old libstdc++
# avoid error: undefined symbol: _ZTVNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEE
# this is a fix for integrations depending on grpcio (google nest, google generativeai and starlink)
# the fix requires to additionally set the LD_LIBRARY_PATH to homeassistant/target/lib
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# libstdc++ is not available for PPC archs
ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/libstdc++
endif
endif

# [voip_utils]
# for voice over ip integration
DEPENDS += cross/opus

# definitions and libraries
# to build wheels of src/requirements-crossenv.txt and src/requirements-abi3.txt
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

# [gevent]
DEPENDS += cross/libev cross/c-ares
ENV += GEVENTSETUP_EMBED_CARES=FALSE
ENV += GEVENTSETUP_EMBED_LIBEV=FALSE

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

include ../../mk/spksrc.python.mk

# prefer native python tools (pip, maturin, ...)
ENV += PATH=$(realpath $(WORK_DIR)/../../../native/$(PYTHON_PACKAGE)/work-native/install/usr/local/bin):$(PATH)

# [greenlet]
ifeq ($(call version_lt, ${TC_GCC}, 5.0),1)
WHEELS_CPPFLAGS += [greenlet] -std=c++11
endif

# [numpy]
# Fix wheel building with older compilers
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CPPFLAGS += [numpy] -std=c++0x
# workaround for compiler bug:
# https://github.com/numpy/numpy/issues/13622
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
WHEELS_CFLAGS += [numpy] -O0
endif
endif

# [protobuf]
ifeq ($(call version_lt, ${TC_GCC}, 5.0),1)
WHEELS_CFLAGS += [protobuf] -std=c99
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
# usage:
# make get_hacs
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
	@install -m 644 src/requirements-custom.txt $(STAGING_DIR)/var/requirements-custom.txt
