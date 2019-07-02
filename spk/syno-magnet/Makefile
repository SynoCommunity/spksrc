PKG_NAME = syno-magnet
PKG_VERS = 1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/neykov/$(PKG_NAME)/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

SPK_NAME = $(PKG_NAME)
SPK_VERS = $(PKG_VERS)
SPK_REV = 2
SPK_ICON = src/magnet.png

MAINTAINER = neykov
DESCRIPTION = Download Station Magnet Handler. Register Download Station as the application to download magnet links from your browser. No plugins required.
DISPLAY_NAME = Download Station Magnet
CHANGELOG = "Initial Version"

HOMEPAGE   = http://github.com/neykov/syno-magnet
LICENSE    = Apache 2.0

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

# Override because we need type: legacy
$(WORK_DIR)/config:
	$(create_target_dir)
	@echo '{ ".url": { ' > $@
	@echo "  \"com.synocommunity.packages.SynoMagnet\": {" >> $@
	@echo "    \"title\": \"${DISPLAY_NAME}\"," >> $@
	@/bin/echo -n "    \"desc\": \"" >> $@
	@/bin/echo -n "${DESCRIPTION}" | sed -e 's/\\//g' -e 's/"/\\"/g' >> $@
	@echo "\",\n    \"icon\": \"images/${SPK_NAME}-{0}.png\"," >> $@
	@echo "    \"type\": \"$(SERVICE_TYPE)\"," >> $@
	@echo "    \"url\": \"${SERVICE_URL}\"," >> $@
	@echo "    \"allUsers\": ${SERVICE_PORT_ALL_USERS}" >> $@
	@echo '} } }' >> $@
	cat $@ | python -m json.tool > /dev/null

syno_magnet_copy: extract $(WORK_DIR)/config
	install -m 755 -d $(STAGING_DIR)/$(DSM_UI_DIR)
	install -m 644 $(WORK_DIR)/config $(STAGING_DIR)/$(DSM_UI_DIR)/config
	cp PLIST $(INSTALL_PLIST)
	(cd $(WORK_DIR)/$(PKG_DIR) && tar cpf - `cat $(INSTALL_PLIST) | cut -d':' -f2` | \
	  tar xpf - -C $(STAGING_DIR)/$(DSM_UI_DIR))
