PKG_NAME = harfbuzz
PKG_VERS = 2.7.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/harfbuzz/harfbuzz/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/cairo cross/fontconfig cross/libicu

HOMEPAGE = https://harfbuzz.github.io/
COMMENT  = HarfBuzz is a text shaping library. Using the HarfBuzz library allows programs to convert a sequence of Unicode input into properly formatted and positioned glyph output—for any writing system and language.
LICENSE  = Old MIT

include ../../mk/spksrc.archs.mk

# Toolchains lacking c++11 compiler ar not supported
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

include ../../mk/spksrc.cross-meson.mk
