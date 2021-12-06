SPK_NAME = sickchill
SPK_VERS = 20211110
SPK_REV = 5
SPK_ICON = src/sickchill.png

BUILD_DEPENDS = cross/python310
DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "python310"

# Required for lxml wheel
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# Required for PyNaCl
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = miigotu
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "1. Migration to Python 3.10<br/>2. SickChill environment fix<br/>3. Added DSM7 Support<br/>4. cryptography resolution for armv7"

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
