PKG_NAME = libicu
PKG_VERS_MAJOR = 67
PKG_VERS_MINOR = 1
PKG_VERS = $(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PKG_EXT = tgz

PKG_DIST_NAME = icu4c-$(PKG_VERS_MAJOR)_$(PKG_VERS_MINOR)-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/unicode-org/icu/releases/download/release-$(PKG_VERS_MAJOR)-$(PKG_VERS_MINOR)
PKG_DIR = icu/source

DEPENDS =

HOMEPAGE = http://site.icu-project.org/home
COMMENT  = International Components for Unicode
LICENSE  = http://www.unicode.org/copyright.html#License

GNU_CONFIGURE = 1

include ../../mk/spksrc.native-cc.mk
