PKG_NAME = xcb-proto
PKG_VERS = 1.17.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/proto
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.x.org
COMMENT  = XCB protocol descriptions.
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --datarootdir=$(INSTALL_PREFIX)/lib

include ../../mk/spksrc.cross-cc.mk
