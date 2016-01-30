PKG_NAME_MASTER = libcdio
PKG_VERS_MASTER = 0.93
PKG_NAME = $(PKG_NAME_MASTER)-paranoia
PKG_VERS = 10.2
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)+$(PKG_VERS_MASTER)+1
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME_MASTER)

DEPENDS = cross/libcdio

HOMEPAGE = http://www.gnu.org/software/libcdio/
COMMENT  = CD player plugin
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk

