PKG_NAME = libraqm
PKG_VERS = 0.10.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/HOST-Oman/libraqm/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/fribidi cross/harfbuzz

# harfbuzz
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
UNSUPPORTED_ARCHS_TCVERSION = x86-5.2

HOMEPAGE = https://host-oman.github.io/libraqm/
COMMENT  = Raqm is a small library that encapsulates the logic for complex text layout and provides a convenient API.
LICENSE  = MIT

include ../../mk/spksrc.cross-meson.mk
