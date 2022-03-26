SPK_NAME = flexget
SPK_VERS = 3.3.4
SPK_REV = 12
SPK_ICON = src/${SPK_NAME}.png

BUILD_DEPENDS = cross/python310
SPK_DEPENDS = "python310"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

# Required for PyYAML
DEPENDS += cross/libyaml

MAINTAINER = SynoCommunity
DESCRIPTION = FlexGet is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds.
DISPLAY_NAME = FlexGet
CHANGELOG = "1. Update FlexGet to version 3.3.4.<br/>2. Update to python 3.10"
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

include ../../mk/spksrc.spk.mk

.PHONY: flexget_extra_install
flexget_extra_install:
	install -m 644 src/config.yml $(STAGING_DIR)/share/
