PKG_NAME = syno-magnet
PKG_VERS = 1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/neykov/$(PKG_NAME)/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

SPK_NAME = $(PKG_NAME)
SPK_VERS = $(PKG_VERS)
SPK_REV = 1
SPK_ICON = src/magnet.png

MAINTAINER = neykov
DESCRIPTION = Download Station Magnet Handler. Register Download Station as the application to download magnet links from your browser. No plugins required.
DISPLAY_NAME = Download Station Magnet
CHANGELOG = "Initial Version"

HOMEPAGE   = http://github.com/neykov/syno-magnet
LICENSE    = Apache 2.0

STARTABLE  = no
DSM_UI_DIR = app

NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
LOCAL_FILE    = $(PKG_DIST_FILE)
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)

COPY_TARGET = syno_magnet_copy

# Pure web package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

include ../../mk/spksrc.download.mk
checksum: download
include ../../mk/spksrc.checksum.mk
extract: checksum
include ../../mk/spksrc.extract.mk

.PHONY: syno_magnet_copy

# Icons already included in download
$(ICON_DIR): ;

syno_magnet_copy: extract
	install -m 755 -d $(STAGING_DIR)/app
	(cd $(WORK_DIR)/$(PKG_DIR) && tar cpf - . | \
	  tar xpf - -C $(STAGING_DIR)/app)
