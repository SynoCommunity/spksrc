PKG_NAME = powershell
PKG_VERS = 7.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/PowerShell/PowerShell/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(INSTALL_DIR)/$(INSTALL_PREFIX)

include ../../mk/spksrc.archs.mk

# use digests with multiple files
PKG_DIST_ARCH_LIST = linux-x64 linux-arm32 linux-arm64

ifeq ($(findstring $(ARCH), $(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = linux-x64
endif
ifeq ($(findstring $(ARCH), $(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = linux-arm32
endif
ifeq ($(findstring $(ARCH), $(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = linux-arm64
endif

ifeq ($(PKG_DIST_ARCH),)
$(error Unsupported ARCH $(ARCH))
endif

HOMEPAGE = https://microsoft.com/PowerShell
COMMENT  = PowerShell Core is a cross-platform automation and configuration tool/framework that works well with your existing tools and is optimized for dealing with structured data (e.g. JSON, CSV, XML, etc.), REST APIs, and object models. It includes a command-line shell, an associated scripting language and a framework for processing cmdlets.
LICENSE  = MIT

# source is extracted directly to the install folder
INSTALL_TARGET = nop

include ../../mk/spksrc.install-resources.mk
