PKG_NAME = bison
PKG_VERS = 2.5
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)

DEPENDS =

HOMEPAGE = http://www.gnu.org/s/bison/
COMMENT  = General-purpose parser generator
LICENSE  = GNU GPL

GNU_CONFIGURE = 1
#FIXME: This override detection of buggy m4/libc6. It is a (very bad) workaround for debian stable
CONFIGURE_ARGS = M4=/usr/bin/m4

include ../../mk/spksrc.cross-cc.mk

