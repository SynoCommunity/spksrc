PKG_NAME = rustdesk-server
PKG_VERS = 1.1.15
PKG_EXT = zip
PKG_DIST_NAME = rustdesk-server-linux-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rustdesk/rustdesk-server/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_DIST_ARCH)

DEPENDS =

HOMEPAGE = https://rustdesk.com/
COMMENT  = RustDesk Server - Self-hosted relay and rendezvous server for RustDesk remote desktop
LICENSE  = AGPL-3.0

INSTALL_TARGET = rustdesk-server_install

include ../../mk/spksrc.archs.mk

# Map spksrc architectures to RustDesk binary architectures
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = amd64
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64v8
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = armv7
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PKG_DIST_ARCH = i386
endif

# Unsupported architectures (no pre-built binary available)
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv7L_ARCHS) $(ARMv5_ARCHS)

include ../../mk/spksrc.install-resources.mk

.PHONY: rustdesk-server_install
rustdesk-server_install:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/hbbs $(STAGING_INSTALL_PREFIX)/bin/
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/hbbr $(STAGING_INSTALL_PREFIX)/bin/
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/rustdesk-utils $(STAGING_INSTALL_PREFIX)/bin/
