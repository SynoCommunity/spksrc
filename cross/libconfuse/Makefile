PKG_NAME = confuse
PKG_VERS = 3.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libconfuse/libconfuse/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/libconfuse/libconfuse#readme
COMMENT  = Small configuration file parser library for C.
LICENSE  = ISC

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk
