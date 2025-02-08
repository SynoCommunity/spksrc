SPK_NAME = dotnet8-runtime
SPK_VERS = 8.0.12
SPK_REV = 4
SPK_ICON = src/dotnet.png

OPTIONAL_DEPENDS = cross/libstdc++
DEPENDS = cross/dotnet8-runtime

REQUIRED_MIN_DSM = 6.0

# Arch exclusions for dotnet
DOTNET_CORE_ARCHS = 1

MAINTAINER = hgy59
DESCRIPTION = Free. Cross-platform. Open source. A developer platform for building all apps. This package installs the dotnet runtime and the asp.net.core runtime.
CHANGELOG = "Update to dotnet-runtime v8.0.12."

STARTABLE = no
DISPLAY_NAME = .NET 8 runtime

HOMEPAGE = https://dotnet.microsoft.com/
LICENSE  = MIT

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# we do not only need the updated libstdc++ library, we also need to
# adjust the library search path for dotnet to use this version.
DEPENDS += cross/libstdc++
POST_STRIP_TARGET = dotnet_patch_target
endif

SPK_COMMANDS = share/dotnet/dotnet

include ../../mk/spksrc.spk.mk

.PHONY: dotnet_patch_target
# Set library path to use bundled libstdc++
dotnet_patch_target:
	@$(MSG) "Set library runpath in dotnet executable."
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/share/dotnet/dotnet
