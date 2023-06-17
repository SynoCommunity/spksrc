SPK_NAME = sickchill
SPK_VERS = 20230530
SPK_REV = 7
SPK_ICON = src/sickchill.png

BUILD_DEPENDS = cross/python310

SPK_DEPENDS = "python310"

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [cryptography]
DEPENDS += cross/cryptography
# ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
# ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/
# ENV += OPENSSL_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
# ENV += OPENSSL_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/

# [greenlet]
#ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
#ifeq ($(call version_ge, ${TC_GCC}, 5.0),1)
#WHEELS += src/requirements-crossenv-greenlet.txt
#else
#CXXFLAGS += -std=c++11
#WHEELS += src/requirements-crossenv-greenlet-gcc4.txt
#endif
DEPENDS += cross/greenlet-2.0.2

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt


MAINTAINER = miigotu
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "Switched to a wheel based install, git installs are no longer supported by upstream."

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

.PHONY: sickchill_extra_install
sickchill_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
