PKG_NAME = nnn
PKG_VERS = 4.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jarun/nnn/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/readline

# compiler too old (-std=c11 required)
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCS) $(ARMv5_ARCHS)

HOMEPAGE = https://github.com/jarun/nnn
COMMENT  = n³ The unorthodox terminal file manager.
LICENSE  = 2-clause BSD

CONFIGURE_TARGET = nop
INSTALL_TARGET = nnn_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: nnn_install
nnn_install:
	@$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
