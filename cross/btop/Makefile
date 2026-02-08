PKG_NAME = btop
PKG_VERS = 1.4.5
PKG_EXT = tbz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/aristocratos/btop/releases/download/v$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS)-$(PKG_DIST_ARCH).$(PKG_EXT)

DEPENDS =

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

HOMEPAGE = https://github.com/aristocratos/btop
COMMENT  = Resource monitor that shows usage and stats for processor, memory, disks, network and processes.
LICENSE  = Apache 2.0

INSTALL_TARGET = btop_install

# use digests with multiple files
PKG_DIST_ARCH_LIST = x86_64-linux-musl i686-linux-musl arm-linux-musleabi aarch64-linux-musl

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x86_64-linux-musl
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PKG_DIST_ARCH = i686-linux-musl
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm-linux-musleabi
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = aarch64-linux-musl
endif

include ../../mk/spksrc.install-resources.mk

.PHONY: btop_install
btop_install:
	@install -Dm755 $(WORK_DIR)/$(PKG_DIR)/btop/bin/btop $(STAGING_INSTALL_PREFIX)/bin/btop
	@install -dm755 $(STAGING_INSTALL_PREFIX)/share/btop/themes
	@install -m664 $(WORK_DIR)/$(PKG_DIR)/btop/themes/* $(STAGING_INSTALL_PREFIX)/share/btop/themes/
