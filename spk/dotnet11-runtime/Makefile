SPK_NAME = dotnet11-runtime
SPK_VERS = 11.0.0
SPK_REV = 1
SPK_ICON = src/dotnet.png

DEPENDS = cross/dotnet11-runtime

# libcoreclr requires glibc >= 2.27 (DSM 7.2+)
MIN_GLIBC_VERSION = 2.27

# Arch exclusions for dotnet
DOTNET_CORE_ARCHS = 1

MAINTAINER = Some Maintainer
DESCRIPTION = Free. Cross-platform. Open source. A developer platform for building all apps. This package installs the dotnet runtime and the asp.net.core runtime.
CHANGELOG = "Initial release of dotnet-runtime v11.0.0."

STARTABLE = no
DISPLAY_NAME = .NET 11 runtime

HOMEPAGE = https://dotnet.microsoft.com/
LICENSE  = MIT

include ../../mk/spksrc.common.mk

SPK_COMMANDS = share/dotnet/dotnet

include ../../mk/spksrc.spk.mk
