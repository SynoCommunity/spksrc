PKG_NAME = jellyfin
PKG_VERS = 12.3
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

# x64 and armv8 only: no .NET 10 runtime for PPC/ARMv5/i686/ARMv7L; .NET 10 arm32 needs
# glibc >= 2.35 + full VFPv3 (excludes armada370, comcerto2k, DSM <= 7.1); and the ARMv7
# models cannot transcode (#5585). It does cross-build for arm32 — this is a support call.
REQUIRE_64BIT = 1

DOTNET_VERSION = 10.0
BUILD_DEPENDS = native/dotnet-sdk-10.0

DOTNET_OUTPUT_PATH = share
DOTNET_PACKAGE_NAME = Jellyfin.Server
# avoid the creation of pdb files
DOTNET_BUILD_PROPERTIES = -p:DebugSymbols=false -p:DebugType=none

include ../../mk/spksrc.cross-dotnet.mk
