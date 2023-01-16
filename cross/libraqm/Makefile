PKG_NAME = libraqm
PKG_VERS = 0.7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = raqm-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/HOST-Oman/libraqm/releases/download/v$(PKG_VERS)
PKG_DIR = raqm-$(PKG_VERS)

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

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
