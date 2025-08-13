PKG_NAME = autobrr
PKG_VERS = 1.65.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS)_linux_$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/autobrr/autobrr/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://autobrr.com/
COMMENT  = Modern, easy to use download automation for torrents and usenet.
LICENSE  = GPLv2

INSTALL_TARGET = autobrr_install

# download prebuilt binaries
# supported archs are x64, ARMv7 and AARCH64
PKG_DIST_ARCH_LIST = x86_64 arm arm64

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x86_64
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
endif


include ../../mk/spksrc.install-resources.mk

.PHONY: autobrr_install
autobrr_install:
	@install -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/autobrr $(STAGING_INSTALL_PREFIX)/bin/
	@install -m 755 $(WORK_DIR)/autobrrctl $(STAGING_INSTALL_PREFIX)/bin/
