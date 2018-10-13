PKG_NAME = jemalloc
PKG_VERS = 3.2.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jemalloc/jemalloc/releases/download/$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# jemalloc is a development tool, replacing standard allocator to diagnose memory leaks.
# It is not included in any package, except to produce test packages for troubleshooting.

HOMEPAGE = http://jemalloc.net/license.html
COMMENT  = General-purpose scalable concurrent malloc(3) implementation
LICENSE  = https://github.com/jemalloc/jemalloc/blob/dev/COPYING

CONFIGURE_ARGS = je_cv_static_page_shift=12
GNU_CONFIGURE = 1

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) DESTDIR=$(INSTALL_DIR) install
