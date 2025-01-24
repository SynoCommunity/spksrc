PKG_NAME = kopia
PKG_VERS = 0.19.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-linux-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kopia/kopia/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)-linux-$(PKG_DIST_ARCH)

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://kopia.io/
COMMENT = Kopia is a fast and secure open-source backup/restore tool that allows you to create encrypted snapshots of your data and save the snapshots to remote or cloud storage of your choice, to network-attached storage or server, or locally on your machine.
LICENSE = Apache 2.0

INSTALL_TARGET = kopia_install

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

.PHONY: kopia_install
kopia_install:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@$(RUN) ; cp -f $(PKG_NAME) $(STAGING_INSTALL_PREFIX)/bin/
	@chmod +x $(STAGING_INSTALL_PREFIX)/bin/$(PKG_NAME)
