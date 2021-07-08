PKG_NAME = jellyfin
PKG_VERS = 10.7.6
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jellyfin/jellyfin/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://jellyfin.org
COMMENT  = The Free Software Media System. It is an alternative to the proprietary Emby and Plex.
LICENSE  = GPLv2

DOTNET_VERSION=5.0
BUILD_DEPENDS = native/dotnet-sdk-$(DOTNET_VERSION)

DOTNET_OPTIMIZE=1
DOTNET_OUTPUT_PATH=share
DOTNET_PACKAGE_NAME=Jellyfin.Server

include ../../mk/spksrc.cross-dotnet.mk
