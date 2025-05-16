SPK_NAME = flexget
SPK_VERS = 3.15.31
SPK_REV = 16
SPK_ICON = src/${SPK_NAME}.png

# Needs atomic to build
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)
PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE)"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = SynoCommunity
DESCRIPTION = FlexGet is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds.
DISPLAY_NAME = FlexGet
CHANGELOG = "1. Update FlexGet to v3.15.31. <br/>2. Migrate to Python 3.12. <br/>3. Avoid config overwrite on package update."
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

include ../../mk/spksrc.archs.mk

# [Pendulum]
# Needs atomic to build
# Serves as maturin type python-wheel.mk example
ifneq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += python/pendulum
endif

# [PyYAML]
DEPENDS += cross/libyaml

# [rpds-py]
# Version >= 0.22.3 requires rustc >= 1.80
ifneq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
WHEELS += src/requirements-crossenv-rpds-py.txt
endif

include ../../mk/spksrc.python.mk

# [greenlet]
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
