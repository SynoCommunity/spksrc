PKG_NAME = jemalloc
PKG_VERS = 5.2.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jemalloc/jemalloc/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# jemalloc is a development tool, replacing standard allocator to diagnose memory leaks.
# It is not included in any package, except to produce test packages for troubleshooting.

HOMEPAGE = https://jemalloc.net/
COMMENT  = General-purpose scalable concurrent malloc(3) implementation.
LICENSE  = 2-Clause BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-doc --disable-static
CONFIGURE_ARGS += je_cv_static_page_shift=12
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
