SPK_NAME = sickchill
SPK_VERS = 20221013
SPK_REV = 6
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
ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = miigotu
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "Switched to a wheel based install, as source and git installs are no longer supported by upstream."

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
