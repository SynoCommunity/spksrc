PKG_NAME = kavita
PKG_VERS = 0.8.3.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-linux-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Kareadita/Kavita/releases/download/v$(PKG_VERS)
PKG_DIR = Kavita

DEPENDS =

HOMEPAGE = https://www.kavitareader.com/
COMMENT  = Kavita is a fast, feature rich, cross platform reading server. Built with a focus for being a full solution for all your reading needs.
LICENSE  = GPLv3

INSTALL_TARGET = kavita_install

# use digests with multiple files
PKG_DIST_ARCH_LIST = x64 arm arm64

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x64
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
endif

include ../../mk/spksrc.install-resources.mk

.PHONY: kavita_install
kavita_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share
	chmod +x $(STAGING_INSTALL_PREFIX)/share/Kavita
