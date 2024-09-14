SPK_NAME = bicbucstriim
SPK_VERS = 1.7.2
SPK_REV = 7
SPK_ICON = src/bicbucstriim.png

DEPENDS = cross/$(SPK_NAME)
# Pure PHP package, make sure ARCH is not defined
override ARCH=

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = WebStation:PHP7.4:Apache2.4

MAINTAINER = SynoCommunity
DESCRIPTION = BicBucStriim streams books, digital books. It fills a gap in the functionality of current NAS devices, which provide access to your collection of music, videos and photos -- but not books. BicBucStriim covers that area and provides web-based access to your e-book collection.
DISPLAY_NAME = BicBucStriim
CHANGELOG = Update to v1.7.2

HOMEPAGE = https://github.com/mikespub-org/rvolz-BicBucStriim/
LICENSE = MIT
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)/LICENSE

WIZARDS_DIR = src/wizard/

SYSTEM_GROUP = http

# Admin link for in DSM UI
ADMIN_URL = /bbs/

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
CONF_DIR = src/conf/

# Set user as 'auto' for DSM 6 privilege
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

POST_STRIP_TARGET = bicbucstriim_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: bicbucstriim_extra_install
bicbucstriim_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/bicbucstriim.conf $(STAGING_DIR)/web/bicbucstriim.conf
	install -m 644 src/web/bicbucstriim.json $(STAGING_DIR)/web/bicbucstriim.json
