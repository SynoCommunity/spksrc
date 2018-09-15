NAME = homeassistant
PKG_NAME = homeassistant
include version
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/home-assistant/home-assistant.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

# scaffolding to allow just a basic git clone as a downloaded archive (from cross-cc)
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Configure the included makefiles
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
LOCAL_FILE    = $(PKG_DIST_FILE)
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)
MSG			= echo

# using the "cross" framework to download and cache specific releases

DEPENDS =

HOMEPAGE = https://www.home-assistant.io/
COMMENT  = Open source home automation that puts local control and privacy first
LICENSE  = Apache License 2.0

all: checksum

.PHONY: configure_target

include ../../mk/spksrc.download.mk

include ../../mk/spksrc.depend.mk

checksum: download
include ../../mk/spksrc.checksum.mk

PRE_CONFIGURE_TARGET = download_target
#GNU_CONFIGURE = 1
