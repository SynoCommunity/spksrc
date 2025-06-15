PKG_NAME = harfbuzz
# latest version that can be built with ARMv7 toolchain
# Not considering v3.x as failing to work with libass
PKG_VERS = 2.9.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/harfbuzz/harfbuzz/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/glib cross/cairo cross/fontconfig

# Toolchains lacking c++11 compiler ar not supported
# this is the latests version with support for ARMv7L
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://harfbuzz.github.io/
COMMENT  = HarfBuzz is a text shaping library. Using the HarfBuzz library allows programs to convert a sequence of Unicode input into properly formatted and positioned glyph output—for any writing system and language.
LICENSE  = Old MIT

CONFIGURE_ARGS = -Dtests=disabled
POST_INSTALL_TARGET = harfbuzz-post-install-target

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, $(TCVERSION), 7),1)
ADDITIONAL_CXXFLAGS += -std=c++11
endif

ifeq ($(findstring $(ARCH), $(ARMv7L_ARCHS)),$(ARCH))
#DEPENDS += cross/gobject-introspection
#CONFIGURE_ARGS += -Dintrospection=disabled
CONFIGURE_ARGS += -Dgobject=disabled
ADDITIONAL_CXXFLAGS += -fpermissive
ADDITIONAL_CXXFLAGS += -Wno-parentheses
ADDITIONAL_CXXFLAGS += -Wno-unused-parameter
ADDITIONAL_CXXFLAGS += -Wno-unused-but-set-variable
endif

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk

.PHONY: harfbuzz-post-install-target
harfbuzz-post-install-target:
	$(RUN) sed -i 's|$(INSTALL_PREFIX)|$(STAGING_INSTALL_PREFIX)|g' $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/harfbuzz*.pc
