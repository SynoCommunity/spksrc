PKG_NAME = dotnet-sdk-6.0
# Version 6.0.5, SDK 6.0.300
# https://dotnet.microsoft.com/download/dotnet/6.0
PKG_VERS = 6.0.300
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
