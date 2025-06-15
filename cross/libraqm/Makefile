PKG_NAME = libraqm
PKG_VERS = 0.8.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = raqm-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/HOST-Oman/libraqm/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/fribidi
OPTIONAL_DEPENDS = cross/harfbuzz cross/harfbuzz_2

# harfbuzz
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += cross/harfbuzz_2
else
DEPENDS += cross/harfbuzz
endif

HOMEPAGE = https://host-oman.github.io/libraqm/
COMMENT  = Raqm is a small library that encapsulates the logic for complex text layout and provides a convenient API.
LICENSE  = MIT

CONFIGURE_ARGS = -Ddocs=false

include ../../mk/spksrc.cross-meson.mk
