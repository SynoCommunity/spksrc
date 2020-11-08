PKG_NAME = gdb
PKG_VERS = 7.6
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/gdb
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/termcap

HOMEPAGE = https://www.gnu.org/software/gdb/
COMMENT  = The GNU Project Debugger
LICENSE  = GPLv2/LGPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
