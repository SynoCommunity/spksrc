PKG_NAME = ombi
PKG_VERS = 4.22.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Ombi-app/Ombi/releases/download/v$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS)-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(INSTALL_DIR)/$(INSTALL_PREFIX)/shared

# use digests with multiple files
PKG_DIST_ARCH_LIST = linux-x64 linux-arm linux-arm64

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH), $(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = linux-x64
endif
ifeq ($(findstring $(ARCH), $(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = linux-arm
endif
ifeq ($(findstring $(ARCH), $(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = linux-arm64
endif

HOMEPAGE = https://ombi.io/
COMMENT  = Want a Movie or TV Show on Plex/Emby/Jellyfin? Use Ombi!
LICENSE  = GPLv2

# source is extracted directly to the install folder
INSTALL_TARGET = nop

include ../../mk/spksrc.install-resources.mk
