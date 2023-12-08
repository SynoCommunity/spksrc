SPK_NAME = bicbucstriim
SPK_VERS = 1.6.6
SPK_REV = 6
SPK_ICON = src/bicbucstriim.png

DEPENDS = cross/$(SPK_NAME)
# Pure PHP package, make sure ARCH is not defined
override ARCH=

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = WebStation:PHP7.4:Apache2.4

MAINTAINER = Diaoul
DESCRIPTION = BicBucStriim streams books, digital books. It fills a gap in the functionality of current NAS devices, which provide access to your collection of music, videos and photos -- but not books. BicBucStriim covers that area and provides web-based access to your e-book collection.
DISPLAY_NAME = BicBucStriim
CHANGELOG = Update to 1.6.6

HOMEPAGE = https://github.com/mikespub-org/rvolz-BicBucStriim
LICENSE = MIT
LICENSE_FILE = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/LICENSE

# Admin link for in DSM UI
ADMIN_URL = /bbs/

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
CONF_DIR = src/conf/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

POST_STRIP_TARGET = bicbucstriim_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: bicbucstriim_extra_install
bicbucstriim_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/bicbucstriim.conf $(STAGING_DIR)/web/bicbucstriim.conf
	install -m 644 src/web/bicbucstriim.json $(STAGING_DIR)/web/bicbucstriim.json
