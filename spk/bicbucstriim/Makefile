SPK_NAME = bicbucstriim
SPK_VERS = 3.5.2
SPK_REV = 8
SPK_ICON = src/bicbucstriim.png

DEPENDS = cross/bicbucstriim
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

REQUIRED_MIN_DSM = 7.0
SPK_DEPENDS = WebStation:PHP8.2:Apache2.4

MAINTAINER = SynoCommunity
DESCRIPTION = BicBucStriim streams books, digital books. It fills a gap in the functionality of current NAS devices, which provide access to your collection of music, videos and photos -- but not books. BicBucStriim covers that area and provides web-based access to your e-book collection.
DISPLAY_NAME = BicBucStriim
CHANGELOG = Update to v3.5.2 \(Requires PHP 8.2\)

HOMEPAGE = https://github.com/mikespub-org/rvolz-BicBucStriim/
LICENSE = MIT
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)/LICENSE

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

include ../../mk/spksrc.spk.mk
