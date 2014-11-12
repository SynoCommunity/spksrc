SPK_NAME = flexget
SPK_VERS = 1.2.197
SPK_REV = 2
SPK_ICON = src/flexget.png
DSM_UI_DIR = app

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel cross/pyyaml
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.6-8"

MAINTAINER = SynoCommunity
DESCRIPTION = FlexGet is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds.
ADMIN_PORT = 8290
RELOAD_UI = yes
DISPLAY_NAME = FlexGet
BETA = 1

HOMEPAGE   = http://flexget.com/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = flexget_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: flexget_extra_install
flexget_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/wheelhouse
	install -m 644 $(WORK_DIR)/wheelhouse/* $(STAGING_DIR)/share/wheelhouse/
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
