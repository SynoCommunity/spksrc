SPK_NAME = dotnet10-runtime
SPK_VERS = 10.0.10
SPK_REV = 4
SPK_ICON = src/dotnet.png

DEPENDS = cross/dotnet10-runtime

# libcoreclr requires glibc >= 2.27 (DSM 7.2+)
MIN_GLIBC_VERSION = 2.27

# Arch exclusions for dotnet
DOTNET_CORE_ARCHS = 1

MAINTAINER = brice-fromentin
DESCRIPTION = Free. Cross-platform. Open source. A developer platform for building all apps. This package installs the dotnet runtime and the asp.net.core runtime.
CHANGELOG = "Update to dotnet-runtime v10.0.10."

STARTABLE = no
DISPLAY_NAME = .NET 10 runtime

HOMEPAGE = https://dotnet.microsoft.com/
LICENSE  = MIT

include ../../mk/spksrc.common.mk

SPK_COMMANDS = share/dotnet/dotnet

include ../../mk/spksrc.spk.mk
