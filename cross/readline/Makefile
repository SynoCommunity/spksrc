PKG_NAME = readline
PKG_VERS = 7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://tiswww.cwru.edu/php/chet/readline/rltop.html
COMMENT  = Set of functions for use by applications that allow users to edit command lines as they are typed in.
LICENSE  = https://www.gnu.org/licenses/gpl.html

GNU_CONFIGURE = 1
CONFIGURE_ARGS = bash_cv_wcwidth_broken=no

include ../../mk/spksrc.cross-cc.mk
