PKG_NAME = mono
PKG_VERS_MAJOR = 4.2.2
PKG_VERS_MINOR = 30
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR).$(PKG_EXT)
PKG_DIST_SITE = http://download.mono-project.com/sources/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS_MAJOR)

DEPENDS = native/$(PKG_NAME)

HOMEPAGE = http://www.mono-project.com
COMMENT  = Cross platform, open source .NET development framework
LICENSE  = http://www.mono-project.com/docs/faq/licensing

REQUIRED_DSM = 5.0
UNSUPPORTED_ARCHS = $(PPC_ARCHES)
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
