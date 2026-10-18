PKG_NAME = unrar
PKG_VERS = 7.1.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.rarlab.com/rar
PKG_DIR = $(PKG_NAME)

DEPENDS =

# unrar builds itself with -std=c++11 and leans on libstdc++ to declare ptrdiff_t
# for it, which the 4.9.3 header chain does not:
#   cmddata.cpp:1243: 'ptrdiff_t' was not declared in this scope
# Builds on gcc 7.5; no toolchain in the tree sits between the two.
MIN_GCC_VERSION = 5

HOMEPAGE = https://rarlab.com
COMMENT  = Extract files from rar archives.
LICENSE  = freeware

CONFIGURE_TARGET = nop
INSTALL_ARGS = install DESTDIR=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
