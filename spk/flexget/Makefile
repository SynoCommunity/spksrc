SPK_NAME = flexget
SPK_VERS = 3.16.3
SPK_REV = 17
SPK_ICON = src/flexget.png

# Python 3.12 not supported for:
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)
# Pendulum not supported for:
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE)"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = SynoCommunity
DESCRIPTION = FlexGet is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds.
DISPLAY_NAME = FlexGet
CHANGELOG = "1. Update FlexGet to v3.16.3."
STARTABLE = yes

HOMEPAGE = https://flexget.com/
LICENSE = MIT

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = flexget_extra_install

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8290
SERVICE_PORT_TITLE = Flexget web ui

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

USE_ALTERNATE_TMPDIR = 1

SPK_USR_LOCAL_LINKS = bin:env/bin/flexget bin:env/bin/flexget-headless

# [Pendulum]
DEPENDS += python/pendulum

# [PyYAML]
DEPENDS += cross/libyaml

include ../../mk/spksrc.python.mk

# [greenlet]
# sqlalchemy has requirement "greenlet >=1", so it is ok to build older version with older toolchains
ifeq ($(call version_ge, $(TC_GCC), 5.0),1)
WHEELS += src/requirements-crossenv-greenlet-v3.txt
else
WHEELS += src/requirements-crossenv-greenlet-v3-gcc4.txt
WHEELS_CPPFLAGS += [greenlet] -std=c++11 -fpermissive
endif

.PHONY: flexget_extra_install
flexget_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/config.yml $(STAGING_DIR)/var/
