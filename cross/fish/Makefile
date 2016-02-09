PKG_NAME = fish
PKG_VERS = 2.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://fishshell.com/files/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses

HOMEPAGE = http://fishshell.com/
COMMENT  = fish is a smart and user-friendly command line shell for OS X, Linux, and the rest of the family.
LICENSE  = GPLv2

UNSUPPORTED_ARCHS = $(PPC_ARCHES)

# GNU_CONFIGURE = 1
CONFIGURE_ARGS = --prefix=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
