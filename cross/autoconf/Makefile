PKG_NAME = autoconf
PKG_VERS = 2.71
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/autoconf/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/m4

HOMEPAGE = https://www.gnu.org/software/autoconf/
COMMENT  = Autoconf is an extensible package of M4 macros that produce shell scripts to automatically configure software source code packages.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
