SPK_NAME = flexget
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 5
SPK_ICON = src/flexget.png

WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.8-11"

MAINTAINER = Diaoul
DESCRIPTION = FlexGet is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds.
DISPLAY_NAME = FlexGet
BETA = 1
CHANGELOG = "1. Update Flexget<br>2. Fix Python 2.7.10 compatibility<br>3. Add \"sc-download\" group to set permissions via DSM"

HOMEPAGE   = http://flexget.com/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = flexget_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: flexget_extra_install
flexget_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/config.yml $(STAGING_DIR)/var/
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/wheelhouse
	install -m 644 $(WORK_DIR)/wheelhouse/* $(STAGING_DIR)/share/wheelhouse/
