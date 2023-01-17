PKG_NAME = libcaca
PKG_VERS = 0.99.beta19
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://caca.zoy.org/files/libcaca
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/imlib2

HOMEPAGE = http://caca.zoy.org/
COMMENT  = The industry-standard colour ASCII-art library.
LICENSE  = WTFPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-python

include ../../mk/spksrc.cross-cc.mk
