SPK_NAME = flexget
SPK_VERS = 3.22.13
SPK_REV = 19
SPK_ICON = src/flexget.png

PYTHON_PACKAGE = python314
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt
# Require python314 SPK that ships built-in _zstd module
SPK_DEPENDS = "python314>=3.14.5-4"

MAINTAINER = SynoCommunity
DESCRIPTION = FlexGet is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds.
DISPLAY_NAME = FlexGet
CHANGELOG = "1. Update FlexGet to v3.22.13. <br/>2. Refresh Python dependencies."
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

# pydantic-core 2.50.5 requires rustc 1.88
MIN_RUSTC_VERSION = 1.88

# The Rust wheels need the binutils 2.30 overlay for the Rust link.
MIN_RUSTC_BINUTILS_VERSION = 2.30

# [brotli]
# GCC < 5.0 (DSM 6.2.4) does not support the 'model' attribute directive
# and requires -std=c99 for C99-style for-loop declarations
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [brotli] -std=gnu99 -Wno-attributes
endif

# [cryptography]
# cryptography 50 builds through maturin and needs the versioned Python include path
DEPENDS += cross/openssl3
WHEELS_CFLAGS += [cryptography] -I$(PYTHON_PACKAGE_WORK_DIR)/install/var/packages/$(PYTHON_PACKAGE)/target/include/python$(PYTHON_PKG_VERS_MAJOR_MINOR)

# [curl-cffi]
DEPENDS += python/curl-cffi

# [Pendulum]
DEPENDS += python/pendulum

# [psutil]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [psutil] -std=c99
endif

# [PyYAML]
DEPENDS += cross/libyaml

include ../../mk/spksrc.spk-meta.mk

.PHONY: flexget_extra_install
flexget_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/config.yml $(STAGING_DIR)/var/
