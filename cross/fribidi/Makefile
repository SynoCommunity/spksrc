PKG_NAME = fribidi
PKG_VERS = 1.0.15
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/fribidi/fribidi/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://fribidi.org/
COMMENT  = GNU FriBidi is an implementation of the Unicode Bidirectional Algorithm (bidi).
LICENSE  = GPLv2

CONFIGURE_ARGS += -Ddocs=false

include ../../mk/spksrc.cross-meson.mk
