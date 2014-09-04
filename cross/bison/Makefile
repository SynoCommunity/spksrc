PKG_NAME = bison
PKG_VERS = 3.0.2
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)

DEPENDS =

HOMEPAGE = http://www.gnu.org/s/bison/
COMMENT  = General-purpose parser generator
LICENSE  = GNU GPL

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk


.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) aclocal
	$(RUN) automake

