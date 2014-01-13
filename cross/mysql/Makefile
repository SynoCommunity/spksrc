PKG_NAME = mysql
PKG_VERS = 5.1.49
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp15.us.freebsd.org/pub/FreeBSD/ports/distfiles
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses

HOMEPAGE = https://dev.mysql.com/downloads/mysql/
COMMENT  = MySQL Community Edition is a freely downloadable version of the world's most popular open source database that is supported by an active community of open source developers and enthusiasts.
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-server --enable-static --enable-shared --without-man --without-docs


include ../../mk/spksrc.cross-cc.mk
