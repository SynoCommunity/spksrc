# Version 9.0.12, SDK 9.0.309
# https://dotnet.microsoft.com/download/dotnet/9.0
PKG_VERS = 9.0.309
PKG_EXT = tar.gz
PKG_NAME = dotnet-sdk-9.0
PKG_DIST_NAME = dotnet-sdk-$(PKG_VERS)-linux-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://builds.dotnet.microsoft.com/dotnet/Sdk/${PKG_VERS}

HOMEPAGE = https://dotnet.microsoft.com/
COMMENT  = A developer platform for building apps.
LICENSE  = MIT

include ../../mk/spksrc.archs.mk

# mostly here to support digesting the right package
PKG_DIST_ARCH_LIST = x64 arm arm64

# Restore original PKG_DIST_ARCH behavior (based on ARCH only)
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x64
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
endif

# Execute the host-detection block ONLY when CARGO_HOME is not empty (set)
ifneq ($(strip $(CARGO_HOME)),)
	HOST_UNAME := $(shell uname -m 2>/dev/null)

	ifneq (,$(findstring aarch64,$(HOST_UNAME)))
		PKG_DIST_ARCH := arm64
	else ifneq (,$(findstring armv7l,$(HOST_UNAME)))
		PKG_DIST_ARCH := arm
	else ifneq (,$(filter x86_64 amd64 i386 i686,$(HOST_UNAME)))
		PKG_DIST_ARCH := x64
	else
		PKG_DIST_ARCH := $(HOST_UNAME)
	endif
endif

# just extract and create folder for nuget packages
INSTALL_TARGET = dotnet_native_install

NUGET_PACKAGES_DIR = $(DISTRIB_DIR)/nuget/packages

include ../../mk/spksrc.native-install.mk

.PHONY: dotnet_native_install
dotnet_native_install:
	@echo "== Environment variables after applying ENV ($(ENV)) =="
	@env $(ENV) sh -lc 'echo "---- Exported environment (env)" ; env | sort'
	@mkdir -p $(NUGET_PACKAGES_DIR)
