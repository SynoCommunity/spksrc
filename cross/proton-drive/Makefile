PKG_NAME = proton-drive
PKG_VERS = 0.9.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ProtonDriveApps/sdk/archive/refs/tags/cli/
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = sdk-cli-v$(PKG_VERS)

CLI_VERSION = $(PKG_VERS)
# To find the latest js version look for tags 
# in https://github.com/ProtonDriveApps/sdk/tags
JS_VERSION = 0.22.2
DISTRIBUTION = synocommunity

BUILD_DEPENDS = native/bun

REQUIRE_64BIT = 1

HOMEPAGE = https://proton.me
COMMENT = The Proton Drive Client provides a high-level interface for interacting with Proton Drive.
LICENSE = MIT

INSTALL_TARGET = protondrive_install

include ../../mk/spksrc.cross-install.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
BUN_CPU = x64
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
BUN_CPU = arm64
endif

PATH := $(WORK_DIR)/../../../native/bun/work-native/install/usr/local/bin:$(PATH)

.PHONY: install_dependencies
install_dependencies:
	@cd $(WORK_DIR)/$(PKG_DIR)/client/js ; bun install --cpu=$(BUN_CPU)
	@cd $(WORK_DIR)/$(PKG_DIR)/incubating/account/js ; bun install --cpu=$(BUN_CPU)
	@cd $(WORK_DIR)/$(PKG_DIR)/cli ; bun install --cpu=$(BUN_CPU)

.PHONY: protondrive_install
protondrive_install: install_dependencies
	@cd $(WORK_DIR)/$(PKG_DIR)/cli ; CLI_APP_VERSION_NAME=cli-drive-$(DISTRIBUTION) CLI_VERSION=$(CLI_VERSION) JS_VERSION=$(JS_VERSION) bun run build bun-linux-$(BUN_CPU)
	@install -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/cli/release/linux-$(BUN_CPU)/proton-drive $(STAGING_INSTALL_PREFIX)/bin/
