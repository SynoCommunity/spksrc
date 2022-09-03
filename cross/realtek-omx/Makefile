PKG_NAME = realtek-omx
PKG_VERS = 2.4.9-1626
PKG_EXT = spk
PKG_DIST_NAME = VideoStation-rtd1296-$(PKG_VERS).$(PKG_EXT)
#PKG_DIST_NAME = $(PKG_NAME)src-$(PKG_VERS).$(PKG_EXT)
#PKG_DIST_SITE = https://archive.synology.com/download/Package/VideoStation/$(PKG_VERS)
PKG_DIST_SITE = https://global.download.synology.com/download/Package/spk/VideoStation/$(PKG_VERS)
#https://global.download.synology.com/download/Package/spk/VideoStation/2.4.9-1626/VideoStation-rtd1296-2.4.9-1626.spk
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://rarlab.com
COMMENT  = Extract files from rar archives.
LICENSE  = freeware

PRE_EXTRACT_TARGET = realtek-libomx_pre-extract
POST_EXTRACT_TARGET = realtek-libomx_post-extract
INSTALL_TARGET = realtek-libomx_install

include ../../mk/spksrc.install-resources.mk

.PHONY: realtek-libomx_pre-extract
realtek-libomx_pre-extract:
	mkdir $(WORK_DIR)/$(PKG_DIR)

.PHONY: realtek-libomx_post-extract
realtek-libomx_post-extract:
	chmod 755 $(WORK_DIR)/$(PKG_DIR)/lib/gstreamer/gstreamer-1.0

.PHONY: realtek-libomx_install
realtek-libomx_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib/realtek
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/lib/realtek . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/lib/realtek
