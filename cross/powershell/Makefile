PKG_NAME = powershell
PKG_VERS = 7.7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-linux-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/PowerShell/PowerShell/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

include ../../mk/spksrc.common.mk

# use digests with multiple files and individual dist names
# both lists must have the same order
PKG_DIST_ARCH_LIST = x64 arm32 arm64

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x64
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm32
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
endif

# No PowerShell build is published for the other archs.
ifeq ($(PKG_DIST_ARCH),)
UNSUPPORTED_ARCHS += $(ARCH)
UNSUPPORTED_ARCHS_REASON = no PowerShell build is published for this arch
endif

HOMEPAGE = https://microsoft.com/PowerShell
COMMENT  = PowerShell is a cross-platform task automation solution made up of a command-line shell, a scripting language, and a configuration management framework.
LICENSE  = MIT

INSTALL_TARGET = powershell_custom_install

include ../../mk/spksrc.cross-install.mk

.PHONY: powershell_custom_install
powershell_custom_install:
	mkdir -p "$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/powershell/"
	tar -cf - -C $(EXTRACT_PATH) . | tar -xf - -C "$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/powershell/"
