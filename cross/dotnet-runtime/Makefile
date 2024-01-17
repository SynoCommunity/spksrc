PKG_NAME = aspnetcore-runtime
PKG_VERS = 6.0.26
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://download.visualstudio.microsoft.com/download/pr/$(PKG_DIST_FOLDER)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

include ../../mk/spksrc.archs.mk

# use digests with multiple files and individual dist names
# both lists must have the same order
PKG_DIST_ARCH_LIST = linux-x64 linux-arm linux-arm64
PKG_DIST_SITE_LIST  = https://download.visualstudio.microsoft.com/download/pr/b63daa46-51f4-480e-ad03-ef2c5a6a2885/ae059763456991305109bf98b3a67640/$(PKG_NAME)-$(PKG_VERS)-linux-x64.$(PKG_EXT)
PKG_DIST_SITE_LIST += https://download.visualstudio.microsoft.com/download/pr/c1d42ac0-cd0c-4188-b260-1667a7443534/f0d1a0b4b88432f1c8d31b467d8548f0/$(PKG_NAME)-$(PKG_VERS)-linux-arm.$(PKG_EXT)
PKG_DIST_SITE_LIST += https://download.visualstudio.microsoft.com/download/pr/cfc40e77-a6de-481f-812d-6867289e2d8b/eeedeebccc412fd01110d8b59050754d/$(PKG_NAME)-$(PKG_VERS)-linux-arm64.$(PKG_EXT)


ifeq ($(findstring $(ARCH), $(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = $(word 1,$(PKG_DIST_ARCH_LIST))
PKG_DIST_FOLDER = $(shell echo $(word 1,$(PKG_DIST_SITE_LIST)) | grep -o1P ".*/download/pr/\K([^/]*/[^/]*)")
endif
ifeq ($(findstring $(ARCH), $(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = $(word 2,$(PKG_DIST_ARCH_LIST))
PKG_DIST_FOLDER = $(shell echo $(word 2,$(PKG_DIST_SITE_LIST)) | grep -o1P ".*/download/pr/\K([^/]*/[^/]*)")
endif
ifeq ($(findstring $(ARCH), $(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = $(word 3,$(PKG_DIST_ARCH_LIST))
PKG_DIST_FOLDER = $(shell echo $(word 3,$(PKG_DIST_SITE_LIST)) | grep -o1P ".*/download/pr/\K([^/]*/[^/]*)")
endif

ifeq ($(PKG_DIST_ARCH),)
$(error Unsupported ARCH $(ARCH))
endif

HOMEPAGE = https://dotnet.microsoft.com/
COMMENT  = Free. Cross-platform. Open source. A developer platform for building all apps.
LICENSE  = MIT

INSTALL_TARGET = dotnet_runtime_custom_install

include ../../mk/spksrc.install-resources.mk

.PHONY: dotnet_runtime_custom_install
dotnet_runtime_custom_install:
	mkdir -p "$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/dotnet/"
	tar -cf - -C $(EXTRACT_PATH) . | tar -xf - -C "$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/dotnet/"
