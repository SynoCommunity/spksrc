SPK_NAME = sickchill
SPK_VERS = 20260918
SPK_REV = 14
SPK_ICON = src/sickchill.png

PYTHON_PACKAGE = python314

# greenlet needs C++20, i.e. gcc >= 8
MIN_GCC_VERSION = 8

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = miigotu
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "1. Update to 2026.9.18. <br/>2. Migrate to Python 3.14."

HOMEPAGE = https://sickchill.github.io/
LICENSE = GPLv3+

SERVICE_USER = auto

SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8081
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

USE_ALTERNATE_TMPDIR = 1

POST_SERVICE_TARGET = sickchill_extra_install

include ../../mk/spksrc.common.mk

# sickchill is not on PyPI (GitHub tags only), build its wheel here
DEPENDS += python/sickchill

# [cryptography]
DEPENDS += cross/openssl3

# [PyYAML]
DEPENDS += cross/libyaml

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

include ../../mk/spksrc.spk-meta.mk

.PHONY: sickchill_extra_install
sickchill_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	@$(MSG) Substituting PYTHON_PACKAGE in service-setup
	@sed -i 's|@@PYTHON_PACKAGE@@|$(PYTHON_PACKAGE)|g' $(WORK_DIR)/scripts/service-setup
