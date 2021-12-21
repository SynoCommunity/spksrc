SPK_NAME = powershell
SPK_VERS = 7.2.1
SPK_REV = 1
SPK_ICON = src/powershell.png

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(i686_ARCHS) $(ARMv7L_ARCHS)

SPK_DEPENDS = dotnet-runtime
DEPENDS = cross/powershell

MAINTAINER = hgy59
DESCRIPTION = PowerShell Core is a cross-platform automation and configuration tool/framework that works well with your existing tools and is optimized for dealing with structured data (e.g. JSON, CSV, XML, etc.), REST APIs, and object models. It includes a command-line shell, an associated scripting language and a framework for processing cmdlets.
CHANGELOG = "Initial package release."

STARTABLE = no
DISPLAY_NAME = PowerShell

HOMEPAGE = https://microsoft.com/PowerShell
LICENSE  = MIT

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# adjust the library search path to use the libraries built for dotnet-runtime.
POST_STRIP_TARGET = powershell_patch_target
endif

SPK_COMMANDS = pwsh

include ../../mk/spksrc.spk.mk

.PHONY: powershell_patch_target
# Set library path to use libstdc++ of dotnet-runtime package.
powershell_patch_target:
	@$(MSG) "Set library runpath in powershell executable (pwsh)."
	@sudo apt-get update 
	@sudo apt-get install -y patchelf
	@patchelf --set-rpath /var/packages/dotnet-runtime/target/lib $(STAGING_DIR)/pwsh
