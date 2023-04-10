PKG_NAME = m4
PKG_VERS = 1.4.19
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/m4/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libiconv

HOMEPAGE = https://www.gnu.org/software/m4/
COMMENT  = GNU M4 is an implementation of the traditional Unix macro processor. It is mostly SVR4 compatible although it has some extensions
LICENSE  = GPLv3

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
