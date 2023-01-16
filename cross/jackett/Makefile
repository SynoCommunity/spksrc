PKG_NAME = Jackett
PKG_VERS = 0.20.1171
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-dotnet-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Jackett/Jackett/archive
PKG_DIR = Jackett-$(PKG_VERS)/src

DOTNET_VERSION = 6.0
BUILD_DEPENDS = native/dotnet-sdk-$(DOTNET_VERSION)

HOMEPAGE = https://github.com/Jackett/Jackett
COMMENT  = Jackett works as a proxy server: it translates queries from apps into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps.
LICENSE  = GNU GPL v2

DOTNET_OPTIMIZE = 1
DOTNET_PACKAGE_NAME = Jackett.Server
DOTNET_OUTPUT_PATH = share
SET_VERSION = /p:AssemblyVersion=$(PKG_VERS) /p:FileVersion=$(PKG_VERS) /p:InformationalVersion=$(PKG_VERS) /p:Version=$(PKG_VERS)
DOTNET_BUILD_PROPERTIES += $(SET_VERSION)

include ../../mk/spksrc.cross-dotnet.mk
