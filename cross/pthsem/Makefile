PKG_NAME = pthsem
PKG_VERS = 2.0.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.auto.tuwien.ac.at/~mkoegler/pth
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.gnu.org/gnu/pth/
COMMENT  = The GNU Portable Threads
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-mctx-mth=sjlj --with-mctx-dsp=ssjlj --with-mctx-stk=sas
POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostInstall
myPostInstall:
	rm -f $(STAGING_INSTALL_PREFIX)/lib/*.so*
	rm -f $(STAGING_INSTALL_PREFIX)/lib/*.la*
