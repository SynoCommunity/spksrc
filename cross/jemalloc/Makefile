PKG_NAME = jemalloc
PKG_VERS = 3.2.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.canonware.com/download/jemalloc
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.canonware.com/jemalloc/
COMMENT  = General-purpose scalable concurrent malloc(3) implementation
LICENSE  = http://www.canonware.com/jemalloc/license.html

CONFIGURE_ARGS = je_cv_static_page_shift=12
GNU_CONFIGURE = 1

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) DESTDIR=$(INSTALL_DIR) install
