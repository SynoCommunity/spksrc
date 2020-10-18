SPK_NAME = flexget
SPK_VERS = 3.1.77
SPK_REV = 7
SPK_ICON = src/flexget.png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.7.7"

MAINTAINER = Diaoul
DESCRIPTION = FlexGet is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds.
DISPLAY_NAME = FlexGet
CHANGELOG = "Update FlexGet to version 3.1.77"

HOMEPAGE   = http://flexget.com/
LICENSE    = MIT

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
CONF_DIR         = src/conf/
WIZARDS_DIR      = src/wizard/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = flexget_extra_install

UNSUPPORTED_ARCHS = $(PPC_ARCHES)

include ../../mk/spksrc.spk.mk

.PHONY: flexget_extra_install
flexget_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/config.yml $(STAGING_DIR)/var/
