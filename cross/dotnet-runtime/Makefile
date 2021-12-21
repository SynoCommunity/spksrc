PKG_NAME = aspnetcore-runtime
PKG_VERS = 6.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://download.visualstudio.microsoft.com/download/pr/$(PKG_DIST_FOLDER)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(INSTALL_DIR)/$(INSTALL_PREFIX)/share/dotnet

include ../../mk/spksrc.archs.mk

# use digests with multiple files and individual dist names
# both lists must have the same order
PKG_DIST_ARCH_LIST = linux-x64 linux-arm linux-arm64
PKG_DIST_SITE_LIST  = https://download.visualstudio.microsoft.com/download/pr/32230fb9-df1e-4b86-b009-12d889cbfa8a/f57a5d92327bb2936caac94bcf602c22/$(PKG_NAME)-$(PKG_VERS)-linux-x64.$(PKG_EXT)
PKG_DIST_SITE_LIST += https://download.visualstudio.microsoft.com/download/pr/ff3b2714-0dee-4cf9-94ee-cb9f5ded285f/d6bfe8668428f9eb28acdf6b6f5a81bc/$(PKG_NAME)-$(PKG_VERS)-linux-arm.$(PKG_EXT)
PKG_DIST_SITE_LIST += https://download.visualstudio.microsoft.com/download/pr/01f8a4af-9d6c-40ff-b834-a1d73105a9d5/aba0525a8b8cb745ac70ecd671acf0e0/$(PKG_NAME)-$(PKG_VERS)-linux-arm64.$(PKG_EXT)

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

# source is extracted directly to the install folder
INSTALL_TARGET = nop

include ../../mk/spksrc.install-resources.mk
