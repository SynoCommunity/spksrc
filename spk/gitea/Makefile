PKG_NAME = gitea
PKG_VERS = 1.8
PKG_EXT = xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-linux-amd64.$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS)-linux-amd64.$(PKG_EXT)
PKG_DIST_SITE = https://dl.gitea.io/gitea/1.8
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

SPK_NAME = $(PKG_NAME)
SPK_VERS = $(PKG_VERS)
SPK_REV = 0
SPK_ICON = src/gitea.png

MAINTAINER = Gitea Authors 
DESCRIPTION = Download Station Magnet Handler. Register Download Station as the application to download magnet links from your browser. No plugins required.
DISPLAY_NAME = Download Station Magnet
CHANGELOG = "Initial Version"

HOMEPAGE   = https://gitea.io
LICENSE    = MIT

STARTABLE  = no
DSM_UI_DIR = app
SERVICE_TYPE = legacy
SERVICE_URL = /webman/3rdparty/syno-magnet/index.html
SERVICE_PORT_ALL_USERS=true

NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
LOCAL_FILE    = $(PKG_DIST_FILE)
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)

COPY_TARGET = gitea_copy

# Pure web package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

include ../../mk/spksrc.download.mk
checksum: download
include ../../mk/spksrc.checksum.mk
extract: checksum
include ../../mk/spksrc.extract.mk

.PHONY: gitea_copy

# Override because we need type: legacy
gitea_copy: extract
	install -m 755 -d $(STAGING_DIR)/$(DSM_UI_DIR)
	install -m 644 $(WORK_DIR)/config $(STAGING_DIR)/$(DSM_UI_DIR)/config
	cp PLIST $(INSTALL_PLIST)
	(cd $(WORK_DIR)/$(PKG_DIR) && tar cpf - `cat $(INSTALL_PLIST) | cut -d':' -f2` | \
	  tar xpf - -C $(STAGING_DIR)/$(DSM_UI_DIR))
