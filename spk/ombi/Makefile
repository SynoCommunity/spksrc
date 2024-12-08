SPK_NAME = ombi
SPK_VERS = 4.44.1
SPK_REV = 5
SPK_ICON = src/ombi.png

REQUIRED_MIN_DSM = 7.2

# Arch exclusions for dotnet 6.0
DOTNET_CORE_ARCHS = 1

DEPENDS = cross/ombi

MAINTAINER = hgy59
DISPLAY_NAME = Ombi
HOMEPAGE = https://ombi.io/
DESCRIPTION = Ombi is a self-hosted web application that automatically gives your shared Plex or Emby users the ability to request content by themselves! Ombi can be linked to multiple TV Show and Movie DVR tools to create a seamless end-to-end experience for your users.
CHANGELOG = "Update Ombi to v4.44.1. (Requires DSM 7.2)"
LICENSE  = GPLv2

SERVICE_USER = auto
SERVICE_PORT = 8822
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
