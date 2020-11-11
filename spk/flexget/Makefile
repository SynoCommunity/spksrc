SPK_NAME = flexget
SPK_VERS = 3.1.79
SPK_REV = 7
SPK_ICON = src/${SPK_NAME}.png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.7.7"

MAINTAINER = manowark
DESCRIPTION = FlexGet is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds.
DISPLAY_NAME = FlexGet
CHANGELOG = "Update FlexGet to version 3.1.79 which now runs on Python 3."
RELOAD_UI = yes
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

include ../../mk/spksrc.spk.mk

.PHONY: flexget_extra_install
flexget_extra_install:
	install -m 644 src/config.yml $(STAGING_DIR)/share/
