PKG_NAME = omx-realtek-libs
PKG_VERS = 2.5.0-1656
PKG_EXT = spk
PKG_DIST_NAME = VideoStation-rtd1296-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://global.download.synology.com/download/Package/spk/VideoStation/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://archive.synology.com/download
COMMENT  = Realtek OMX hardware acceleration libraries for use with ARMv8 (aarch64) Synology NAS
LICENSE  = unknown

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(x64_ARCHS) $(i686_ARCHS)

PRE_EXTRACT_TARGET = omx-realtek_pre-extract
POST_EXTRACT_TARGET = omx-realtek_post-extract
INSTALL_TARGET = omx-realtek_install

include ../../mk/spksrc.install-resources.mk

.PHONY: omx-realtek_pre-extract
omx-realtek_pre-extract:
	mkdir $(WORK_DIR)/$(PKG_DIR)

.PHONY: omx-realtek_post-extract
omx-realtek_post-extract:
	chmod 755 $(WORK_DIR)/$(PKG_DIR)/lib/gstreamer/gstreamer-1.0

.PHONY: omx-realtek_install
omx-realtek_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib/realtek
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/lib/realtek . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/lib/realtek
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/etc/gstomx.conf $(STAGING_INSTALL_PREFIX)/etc
	sed -i -e 's?/var/packages/VideoStation/target?$(INSTALL_PREFIX)?g' $(STAGING_INSTALL_PREFIX)/etc/gstomx.conf
