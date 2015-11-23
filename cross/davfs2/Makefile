PKG_NAME = davfs2
PKG_VERS = 1.5.2
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
#PKG_DIR = $(PKG_NAME)-
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.savannah.gnu.org/releases/$(PKG_NAME)

DEPENDS = cross/neon cross/libtool

HOMEPAGE = test
COMMENT  = General-purpose parser generator
LICENSE  = GNU GPL

export ssbindir=$(STAGING_INSTALL_PREFIX)/sbin/
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-neon=$(STAGING_INSTALL_PREFIX)
export ac_cv_func_malloc_0_nonnull=yes
export ac_cv_func_realloc_0_nonnull=yes
include ../../mk/spksrc.cross-cc.mk

