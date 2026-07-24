PKG_NAME = cgif
PKG_VERS = 0.5.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dloebl/cgif/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/dloebl/cgif
COMMENT  = cgif is a GIF encoder library written in C.
LICENSE  = MIT

CONFIGURE_ARGS = -Dexamples=false -Dtests=false -Dfuzzer=false

include ../../mk/spksrc.cross-meson.mk
