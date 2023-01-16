PKG_NAME = libicu
PKG_VERS = 71.1
PKG_EXT = tgz
PKG_DIST_NAME = icu4c-$(subst .,_,$(PKG_VERS))-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/unicode-org/icu/releases/download/release-$(subst .,-,$(PKG_VERS))
PKG_DIR = icu/source

DEPENDS =

HOMEPAGE = http://site.icu-project.org/home
COMMENT  = International Components for Unicode
LICENSE  = http://www.unicode.org/copyright.html#License

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --disable-samples --disable-tests

include ../../mk/spksrc.native-cc.mk
