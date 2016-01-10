PKG_NAME = bash
PKG_VERS = 4.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/bash
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses

HOMEPAGE = http://www.gnu.org/software/bash/
COMMENT  = Bash is the GNU Project's shell. Bash is the Bourne Again SHell. Bash is an sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh).
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = bash_cv_dev_fd=whacky

include ../../mk/spksrc.cross-cc.mk
