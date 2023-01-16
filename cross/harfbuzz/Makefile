PKG_NAME = harfbuzz
PKG_VERS = 5.3.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/harfbuzz/harfbuzz/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/glib cross/cairo cross/fontconfig

# Toolchains lacking c++11 compiler ar not
# supported neither are compiliers <= 4.9
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://harfbuzz.github.io/
COMMENT  = HarfBuzz is a text shaping library. Using the HarfBuzz library allows programs to convert a sequence of Unicode input into properly formatted and positioned glyph output—for any writing system and language.
LICENSE  = Old MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = -Dtests=disabled

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, $(TCVERSION), 7),1)
ADDITIONAL_CFLAGS = -std=c11
endif

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk
