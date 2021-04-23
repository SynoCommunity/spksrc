PKG_NAME = Lidarr
PKG_VERS = 0.8.0.2042
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).develop.$(PKG_VERS).linux-core-$(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lidarr/$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_DIR = Lidarr

DEPENDS =

UNSUPPORTED_ARCHS = $(i686_ARCHS) $(ARMv7L_ARCHS) $(ARMv5_ARCHS) $(PPC_ARCHS)

HOMEPAGE = https://lidarr.audio/
COMMENT  = Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
LICENSE  = GPLv3

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = lidarr_install

include ../../mk/spksrc.archs.mk
PKG_ARCH = x64
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_ARCH = arm
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_ARCH = arm64
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: lidarr_install
lidarr_install:
	rm -rf $(WORK_DIR)/$(PKG_DIR)/Lidarr.Update
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin


# digests file contains check sums for all PKG_ARCH specific source files.
# Use 'make update-digests' to update digests file once for new PKG_VERS
# This will download the sources and create the cumulated digests file.
# ARCH mappings: 
# - x64:   GENERIC_x64_ARCH
# - arm:   GENERIC_ARMv7_ARCH
# - arm64: GENERIC_ARMv8_ARCH
.PHONY: update-digests
update-digests:
	@echo "=== Create digests file ==="; \
	export TCVERSION=6.1 ; \
	tmp_digests=digests.tmp ; \
	>$$tmp_digests ; \
	for _arch in $(GENERIC_x64_ARCH) $(GENERIC_ARMv7_ARCH) $(GENERIC_ARMv8_ARCH); do \
	  echo "add digests for $$_arch" ; \
	  $(MAKE) -C . digests ARCH=$$_arch > /dev/null ; \
	  cat digests >> $$tmp_digests ; \
	done ; \
	rm -f digests ; \
	mv $$tmp_digests digests ; \
	echo ""=== Please verify checksums with original sources. "===" ; \
	cat digests ; \
	exit 0

