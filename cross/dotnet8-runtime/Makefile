PKG_NAME = aspnetcore-runtime
PKG_VERS = 8.0.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://download.visualstudio.microsoft.com/download/pr/$(PKG_DIST_FOLDER)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

include ../../mk/spksrc.archs.mk

# use digests with multiple files and individual dist names
# both lists must have the same order
PKG_DIST_ARCH_LIST = linux-x64 linux-arm linux-arm64
PKG_DIST_SITE_LIST  = https://download.visualstudio.microsoft.com/download/pr/0b0bc7f4-c6e5-4cec-a7ed-45c2fac0da4b/ae2090564274152b5a4be9f1e66c5d30/$(PKG_NAME)-$(PKG_VERS)-linux-x64.$(PKG_EXT)
PKG_DIST_SITE_LIST += https://download.visualstudio.microsoft.com/download/pr/f12a9449-04ba-454c-bc35-4cdb426accf6/2729a371b61d59794845eb309a46fba2/$(PKG_NAME)-$(PKG_VERS)-linux-arm.$(PKG_EXT)
PKG_DIST_SITE_LIST += https://download.visualstudio.microsoft.com/download/pr/80ec12e5-b26f-466c-a20c-f96772ea709d/606e7203912400b44cb35d6fcecf60bf/$(PKG_NAME)-$(PKG_VERS)-linux-arm64.$(PKG_EXT)

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
