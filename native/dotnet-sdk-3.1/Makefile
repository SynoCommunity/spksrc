PKG_NAME = dotnet-sdk-3.1
# Version 3.1.16, SDK 3.1.410
# https://github.com/dotnet/core/blob/main/release-notes/3.1/3.1.16/3.1.410-download.md
PKG_VERS = 3.1.410
PKG_EXT = tar.gz
PKG_DIST_NAME = dotnet-sdk-$(PKG_VERS)-linux-x64.$(PKG_EXT)
PKG_DIST_SITE = https://dotnetcli.azureedge.net/dotnet/Sdk/${PKG_VERS}

HOMEPAGE = https://dotnet.microsoft.com/
COMMENT  = A developer platform for building apps.
LICENSE  = MIT

INSTALL_TARGET = dotnet-install

DOTNET_PACKAGES=$(DISTRIB_DIR)/nuget/packages

include ../../mk/spksrc.native-install.mk

.PHONY: dotnet-install
dotnet-install:
	mkdir -p $(DOTNET_PACKAGES)
