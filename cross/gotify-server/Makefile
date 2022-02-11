PKG_NAME = gotify-server
PKG_VERS = 2.1.4
PKG_EXT = zip
PKG_DIST_NAME = gotify-linux-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gotify/server/releases/download/v$(PKG_VERS)

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

HOMEPAGE = https://gotify.net/
COMMENT  = A simple server for sending and receiving messages
LICENSE  = MIT

INSTALL_TARGET = gotify-server_install

# use digests with multiple files
PKG_DIST_ARCH_LIST = amd64 386 arm-7 arm64

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = amd64
else ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PKG_DIST_ARCH = 386
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm-7
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
endif

include ../../mk/spksrc.install-resources.mk

.PHONY: gotify-server_install
gotify-server_install:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@cp -f $(WORK_DIR)/gotify-linux-$(PKG_DIST_ARCH) $(STAGING_INSTALL_PREFIX)/bin/gotify-server
