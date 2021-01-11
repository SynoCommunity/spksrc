PKG_NAME = dotnet-sdk-5.0
PKG_VERS = 5.0.100
PKG_EXT = tar.gz
PKG_DIST_SITE = https://dotnetcli.azureedge.net/dotnet/Sdk/${PKG_VERS}
PKG_DIST_NAME = dotnet-sdk-$(PKG_VERS)-linux-x64.$(PKG_EXT)

# https://docs.microsoft.com/en-us/dotnet/core/install/dependencies?pivots=os-linux&tabs=netcore31
DEPENDS =

HOMEPAGE = https://dotnet.microsoft.com/
COMMENT  = A developer platform for building apps.
LICENSE  = MIT

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = dotnet-install

DOTNET_PACKAGES=$(DISTRIB_DIR)/nuget/packages

include ../../mk/spksrc.native-cc.mk

# Supported architectures:
# https://github.com/dotnet/core/blob/master/release-notes/3.1/3.1-supported-os.md#linux
## UNSUPPORTED_ARCHS = $(PPC_ARCHES) $(ARM5_ARCHES) $(x86_ARCHES)

.PHONY: dotnet-install
dotnet-install:
	mkdir -p $(DOTNET_PACKAGES)
