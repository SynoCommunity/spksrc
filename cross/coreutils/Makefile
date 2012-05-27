PKG_NAME = coreutils
PKG_VERS = 8.17
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.gnu.org/s/coreutils/
COMMENT  = Basic file, shell and text manipulation utilities of the GNU operating system
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-nls gl_cv_func_realpath_works=yes

include ../../mk/spksrc.cross-cc.mk

