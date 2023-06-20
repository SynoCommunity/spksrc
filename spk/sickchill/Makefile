SPK_NAME = sickchill
SPK_VERS = 20230530
SPK_REV = 7
SPK_ICON = src/sickchill.png

BUILD_DEPENDS = cross/python310

SPK_DEPENDS = "python310"

# archs without C++11 support are not supported:
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [cryptography]
# DEPENDS += cross/cryptography
# ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
# ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/
# ENV += OPENSSL_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
# ENV += OPENSSL_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/
ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/
# fix for openssl-sys crate (for cryptography >= 40.0.0)
# https://docs.rs/openssl/latest/openssl/#manual
ENV += OPENSSL_DIR=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.common.mk

# [greenlet]
ifeq ($(call version_lt, ${TC_GCC}, 5.0),1)
WHEELS_CPPFLAGS = [greenlet] -std=c++11
endif

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt


MAINTAINER = miigotu
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "A wheel based install, git installs are not supported by upstream.<br/>Deprecated ARMv5 (88f628x) as no compiler support for updated dependencies."

HOMEPAGE   = https://sickchill.github.io/
LICENSE    = GPLv3+

SERVICE_USER = auto

SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8081
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

USE_ALTERNATE_TMPDIR = 1

POST_STRIP_TARGET = sickchill_extra_install

include ../../mk/spksrc.spk.mk
# prefere native python tools (pip, maturin, ...)
ENV += PATH=$(realpath $(WORK_DIR)/../../../native/python310/work-native/install/usr/local/bin):$(PATH)

.PHONY: sickchill_extra_install
sickchill_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
