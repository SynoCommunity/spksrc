SPK_NAME = sickchill
SPK_VERS = 20240301
SPK_REV = 11
SPK_ICON = src/sickchill.png

PYTHON_PACKAGE = python311

SPK_DEPENDS = "python311>=3.11.5-8"

# archs without C++11 support are not supported [greenlet]
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [cryptography]
DEPENDS += cross/cryptography

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt


MAINTAINER = miigotu
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "1. A wheel based install, git installs not supported by upstream.<br/>2. Python update to 3.11.10, OpenSSL 3.1.7<br/>3. Deprecated ARMv5 (88f628x) as no compiler support for updated dependencies"

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

POST_STRIP_TARGET = sickchill_extra_install

include ../../mk/spksrc.python.mk


ifeq ($(call version_lt, $(TC_GCC), 4.8.1),1)
# archs without C++11 support are not supported [greenlet]
UNSUPPORTED_ARCHS = $(ARCH)
endif

# [greenlet]
ifeq ($(call version_lt, ${TC_GCC}, 5.0),1)
WHEELS_CPPFLAGS = [greenlet] -std=c++11 -fpermissive
# supported version <=3.1.0
WHEELS += src/requirements-crossenv-greenlet-v3.txt
else
WHEELS += src/requirements-crossenv-greenlet-latest.txt
endif

# prefere native python tools (pip, maturin, ...)
ENV += PATH=$(abspath $(WORK_DIR)/../../../native/python311/work-native/install/usr/local/bin):$(PATH)

.PHONY: sickchill_extra_install
sickchill_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
