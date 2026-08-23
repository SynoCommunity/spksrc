PKG_NAME = nnn
PKG_VERS = 5.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jarun/nnn/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/readline

MIN_GCC_VERSION = 5.0

HOMEPAGE = https://github.com/jarun/nnn
COMMENT  = n³ The unorthodox terminal file manager.
LICENSE  = 2-clause BSD

CONFIGURE_TARGET = nop
INSTALL_ARGS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
