SPK_NAME = dotnet10-runtime
SPK_VERS = 10.0.2
SPK_REV = 3
SPK_ICON = src/dotnet.png

DEPENDS = cross/dotnet10-runtime

# GLIBC >= 2.27 required
REQUIRED_MIN_DSM = 7.2

# Arch exclusions for dotnet
DOTNET_CORE_ARCHS = 1

MAINTAINER = brice-fromentin
DESCRIPTION = Free. Cross-platform. Open source. A developer platform for building all apps. This package installs the dotnet runtime and the asp.net.core runtime.
CHANGELOG = "Update to dotnet-runtime v10.0.2."

STARTABLE = no
DISPLAY_NAME = .NET 10 runtime

HOMEPAGE = https://dotnet.microsoft.com/
LICENSE  = MIT

include ../../mk/spksrc.common.mk

SPK_COMMANDS = share/dotnet/dotnet

include ../../mk/spksrc.spk.mk
