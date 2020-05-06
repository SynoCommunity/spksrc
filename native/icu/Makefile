PKG_NAME = icu
PKG_VERS = 65
PKG_MINOR_VERS = 1
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)4c-$(PKG_VERS)_$(PKG_MINOR_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/unicode-org/icu/releases/download/release-$(PKG_VERS)-$(PKG_MINOR_VERS)
PKG_DIR = $(PKG_NAME)/source

DEPENDS = 

HOMEPAGE = http://site.icu-project.org/
COMMENT  = ICU is a mature, widely used set of libraries providing Unicode and Globalization support for software applications.
LICENSE  = Unicode Copyright

NATIVE_CPPFLAGS = -O3 -fno-short-wchar -DU_USING_ICU_NAMESPACE=1 -fno-short-enums -DU_HAVE_NL_LANGINFO_CODESET=0 -D__STDC_INT64__ -DU_TIMEZONE=0 -DUCONFIG_NO_LEGACY_CONVERSION=1 -DUCONFIG_NO_BREAK_ITERATION=1 -DUCONFIG_NO_COLLATION=1 -DUCONFIG_NO_FORMATTING=1 -DUCONFIG_NO_TRANSLITERATION=0 -DUCONFIG_NO_REGULAR_EXPRESSIONS=1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-static --enable-shared=no --disable-dyload
CONFIGURE_ARGS += --enable-extras=no --enable-strict=no --enable-tests=no --enable-samples=no
# CONFIGURE_ARGS += --with-data-packaging=files

include ../../mk/spksrc.native-cc.mk
