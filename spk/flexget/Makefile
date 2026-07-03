SPK_NAME = flexget
SPK_VERS = 3.19.22
SPK_REV = 18
SPK_ICON = src/flexget.png

# Python 3.14 not supported for:
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)
# Pendulum not supported for:
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

PYTHON_PACKAGE = python314
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt
# Require python314 SPK that ships built-in _zstd module
SPK_DEPENDS = "python314>=3.14.5-4"

MAINTAINER = SynoCommunity
DESCRIPTION = FlexGet is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds.
DISPLAY_NAME = FlexGet
CHANGELOG = "1. Update FlexGet to v3.19.22. <br/>2. Refresh Python dependencies."
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

include ../../mk/spksrc.common.mk

# [brotli]
# GCC < 5.0 (DSM 6.2.4) does not support the 'model' attribute directive
# and requires -std=c99 for C99-style for-loop declarations
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [brotli] -std=gnu99 -Wno-attributes
endif

# [greenlet]
# version >= 3.1: gcc >= 8   (DSM7.1+) Mandatory require full c++20 support (designated initializers)
# version  = 3.0: gcc >= 4.9 (DSM6, comcerto2k) Python 3.12 support only, NOT compatible with Python 3.14
# For GCC < 8, greenlet is skipped entirely. SQLAlchemy (the consumer of greenlet)
# works without it in sync mode, so no functionality is lost.
ifeq ($(call version_ge, $(TC_GCC), 8.0),1)
WHEELS += greenlet==3.3.2
endif

# [Pendulum]
DEPENDS += python/pendulum

# [psutil]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [psutil] -std=c99
endif

# [PyYAML]
DEPENDS += cross/libyaml

# [rpds-py]
# Version = 0.24 requires rustc >= 1.82 (qoriq)
# Version = 0.25 requires rustc >= 1.85
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1
WHEELS += rpds_py==0.24.0
else
WHEELS += rpds_py==0.30.0
endif

include ../../mk/spksrc.spk-meta.mk

.PHONY: flexget_extra_install
flexget_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/config.yml $(STAGING_DIR)/var/
