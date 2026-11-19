SPK_NAME = powershell
SPK_VERS = 7.7.0
SPK_REV = 1
SPK_ICON = src/powershell.png

DEPENDS = cross/powershell

# PowerShell 7.7 bundles .NET 11, whose libcoreclr requires glibc >= 2.27 (DSM 7.2+)
MIN_GLIBC_VERSION = 2.27

# Arch exclusions for dotnet
DOTNET_CORE_ARCHS = 1

MAINTAINER = Some Maintainer
DESCRIPTION = PowerShell is a cross-platform task automation solution made up of a command-line shell, a scripting language, and a configuration management framework.
CHANGELOG = "Initial release of PowerShell v7.7.0."

STARTABLE = no
DISPLAY_NAME = PowerShell

HOMEPAGE = https://microsoft.com/PowerShell
LICENSE  = MIT

include ../../mk/spksrc.common.mk

SPK_COMMANDS = share/powershell/pwsh

include ../../mk/spksrc.spk.mk
