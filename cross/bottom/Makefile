PKG_NAME = bottom
PKG_VERS = 0.11.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ClementTsang/bottom/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)
# requires rust 1.85 but for qoriq we have only 1.82
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

HOMEPAGE = https://clementtsang.github.io/bottom
COMMENT  = A customizable cross-platform graphical process/system monitor for the terminal.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk
