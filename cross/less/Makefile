PKG_NAME = less
PKG_VERS = 563
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/less/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://www.gnu.org/software/less/
COMMENT  = GNU less is a program similar to more, but which allows backward movement in the file as well as forward movement. Also, less does not have to read the entire input file before starting, so with large input files it starts up faster than text editors like vi. Less uses termcap (or terminfo on some systems), so it can run on a variety of terminals.
LICENSE  = GPLv3

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
