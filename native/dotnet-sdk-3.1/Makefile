PKG_NAME = dotnet-sdk-3.1
# PKG_VERS = SDK 3.1.404 (v3.1.10 release)
# https://github.com/dotnet/core/blob/master/release-notes/3.1/3.1.9/3.1.9.md
PKG_VERS = 3.1.404
PKG_EXT = tar.gz
# https://download.visualstudio.microsoft.com/download/pr/ec187f12-929e-4aa7-8abc-2f52e147af1d/56b0dbb5da1c191bff2c271fcd6e6394/dotnet-sdk-3.1.404-linux-x64.tar.gz
PKG_DIST_SITE = https://dotnetcli.azureedge.net/dotnet/Sdk/${PKG_VERS}
PKG_DIST_NAME = dotnet-sdk-$(PKG_VERS)-linux-x64.$(PKG_EXT)

HOMEPAGE = https://dotnet.microsoft.com/
COMMENT  = A developer platform for building apps.
LICENSE  = MIT

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = dotnet-install

DOTNET_PACKAGES=$(DISTRIB_DIR)/nuget/packages

include ../../mk/spksrc.native-cc.mk

.PHONY: dotnet-install
dotnet-install:
	mkdir -p $(DOTNET_PACKAGES)
