PKG_NAME = psmisc
PKG_VERS = 23.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/psmisc/files/psmisc
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses

HOMEPAGE = https://gitlab.com/psmisc/psmisc
COMMENT  = Miscellaneous utilities that use the proc file-system
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = ac_cv_func_malloc_0_nonnull=yes
CONFIGURE_ARGS += ac_cv_func_realloc_0_nonnull=yes

include ../../mk/spksrc.cross-cc.mk
