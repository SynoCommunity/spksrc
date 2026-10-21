PKG_NAME = unrar
PKG_VERS = 6.2.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.rarlab.com/rar
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://rarlab.com
COMMENT  = Extract files from rar archives.
LICENSE  = freeware

# unrar compiles with -std=c++11, which gcc accepts from 4.7:
#   cc1plus: error: unrecognized command line option '-std=c++11'
MIN_GCC_VERSION = 4.7

CONFIGURE_TARGET = nop
INSTALL_ARGS = install DESTDIR=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
