PKG_NAME = jellyfin
PKG_VERS = 10.11.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jellyfin/jellyfin/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# font for library thumbnail
DEPENDS += cross/dejavu

HOMEPAGE = https://jellyfin.org
COMMENT  = The Free Software Media System. It is an alternative to the proprietary Emby and Plex.
LICENSE  = GPLv2

DOTNET_VERSION = 9.0
BUILD_DEPENDS = native/dotnet-sdk-9.0

DOTNET_OUTPUT_PATH = share
DOTNET_PACKAGE_NAME = Jellyfin.Server
# avoid the creation of pdb files
DOTNET_BUILD_PROPERTIES = -p:DebugSymbols=false -p:DebugType=none

include ../../mk/spksrc.cross-dotnet.mk
