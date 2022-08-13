SPK_NAME = ombi
SPK_VERS = 4.22.5
SPK_REV = 1
SPK_ICON = src/ombi.png

UNSUPPORTED_ARCHS = $(DOTNET_UNSUPPORTED_ARCHS)
UNSUPPORTED_ARCHS_TCVERSION = armv7-1.2

DEPENDS = cross/ombi
OPTIONAL_DEPENDS = cross/libstdc++

MAINTAINER = hgy59
DISPLAY_NAME = Ombi
HOMEPAGE = https://ombi.io/
DESCRIPTION = Ombi is a self-hosted web application that automatically gives your shared Plex or Emby users the ability to request content by themselves! Ombi can be linked to multiple TV Show and Movie DVR tools to create a seamless end-to-end experience for your users.
CHANGELOG = "Initial package release."
LICENSE  = GPLv2

SERVICE_USER = auto
SERVICE_PORT = 8822
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# we do not only need the updated libstdc++ library, we also need to
# adjust the library search path in ombi executables to use this version.
DEPENDS += cross/libstdc++
POST_STRIP_TARGET = ombi_patch_target
endif

include ../../mk/spksrc.spk.mk

.PHONY: ombi_patch_target
# Set library path to use libstdc++ of dotnet-runtime package.
ombi_patch_target:
	@$(MSG) "Set library runpath in ombi executables."
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/shared/Ombi
	@patchelf --set-rpath /var/packages/$(SPK_NAME)/target/lib $(STAGING_DIR)/shared/Ombi.Updater
