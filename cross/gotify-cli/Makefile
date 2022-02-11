PKG_NAME = gotify-cli
PKG_VERS = 2.2.1
PKG_DIST_NAME = gotify-cli-linux-$(PKG_DIST_ARCH)
PKG_DIST_SITE = https://github.com/gotify/cli/releases/download/v$(PKG_VERS)

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

HOMEPAGE = https://gotify.net/
COMMENT  = A command line interface for pushing messages to gotify/server.
LICENSE  = MIT

INSTALL_TARGET = gotify-cli_install

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

.PHONY: gotify-cli_install
gotify-cli_install:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@cp -f $(DIST_FILE) $(STAGING_INSTALL_PREFIX)/bin/gotify-cli
	@chmod +x $(STAGING_INSTALL_PREFIX)/bin/gotify-cli
