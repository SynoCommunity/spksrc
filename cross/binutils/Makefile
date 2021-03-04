PKG_NAME = binutils
PKG_VERS = 2.36.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = The GNU Binutils are a collection of binary tools.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --program-prefix=$(TC_TARGET)-

include ../../mk/spksrc.cross-cc.mk
