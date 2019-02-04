PKG_NAME = fribidi
PKG_VERS = 1.0.5
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/fribidi/fribidi/releases/download/v$(PKG_VERS)

PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://fribidi.org/
COMMENT  = GNU FriBidi is an implementation of the Unicode Bidirectional Algorithm (bidi).
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-pic

include ../../mk/spksrc.cross-cc.mk
