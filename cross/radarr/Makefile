PKG_NAME = Radarr
PKG_VERS = 3.0.0.4204
PKG_EXT = tar.gz
# Define PKG_ARCH for compiler
ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
	PKG_ARCH = arm
endif
ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
	PKG_ARCH = arm64
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
	PKG_ARCH = x64
endif
ifeq ($(PKG_ARCH),)
	# don't report error to use regular UNSUPPORTED_ARCHS logging
	$(warning Unsupported ARCH $(ARCH))
endif
PKG_DIST_NAME = $(PKG_NAME).master.$(PKG_VERS).linux-core-$(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Radarr/Radarr/releases/download/v$(PKG_VERS)
PKG_DIR = Radarr

DEPENDS =

HOMEPAGE = https://radarr.video/
COMMENT  = Radarr is a movie manager like Couchpotato, but based on the Sonarr codebase. It can monitor multiple RSS feeds for new movie releases and will grab, sorts and rename them. It can also be configured to automatically upgrade the quality of files already downloaded if a better quality format becomes available.
LICENSE  = GNU GPL v3

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = radarr_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: radarr_install
radarr_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
