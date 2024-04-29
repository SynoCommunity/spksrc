SPK_NAME = flexget
SPK_VERS = 3.7.10
SPK_REV = 13
SPK_ICON = src/${SPK_NAME}.png

PYTHON_PACKAGE = python311
SPK_DEPENDS = "python311>=3.11.4-7"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = SynoCommunity
DESCRIPTION = FlexGet is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds.
DISPLAY_NAME = FlexGet
CHANGELOG = "1. Update FlexGet to version 3.7.10<br/>2. Migrate to python 3.11"
STARTABLE = yes

HOMEPAGE = https://flexget.com/
LICENSE = MIT

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = flexget_extra_install

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8290
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

USE_ALTERNATE_TMPDIR = 1

SPK_USR_LOCAL_LINKS = bin:env/bin/flexget bin:env/bin/flexget-headless

# [cryptography]
DEPENDS += cross/cryptography

# [greenlet] == 2.0.1
# gcc < 4.9 only supports greenlet v1.x
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

# [PyYAML]
DEPENDS += cross/libyaml

include ../../mk/spksrc.python.mk

# [greenlet] == 2.0.1
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CPPFLAGS += [greenlet] -std=c++11 -fpermissive
endif

.PHONY: flexget_extra_install
flexget_extra_install:
	install -m 644 src/config.yml $(STAGING_DIR)/share/
