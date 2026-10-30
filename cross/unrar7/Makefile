PKG_NAME = unrar
PKG_VERS = 7.1.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.rarlab.com/rar
PKG_DIR = $(PKG_NAME)

DEPENDS =

# unrar builds with -std=c++11 and leans on libstdc++ to declare ptrdiff_t for
# it, which it does from gcc 5:
#   cmddata.cpp:1243: 'ptrdiff_t' was not declared in this scope
MIN_GCC_VERSION = 5

HOMEPAGE = https://rarlab.com
COMMENT  = Extract files from rar archives.
LICENSE  = freeware

CONFIGURE_TARGET = nop
INSTALL_ARGS = install DESTDIR=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
