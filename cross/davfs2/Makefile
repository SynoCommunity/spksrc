PKG_NAME = davfs2
PKG_VERS = 1.5.5
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.savannah.gnu.org/releases/$(PKG_NAME)

DEPENDS = cross/neon cross/libtool
DESCRIPTION = Mount a WebDAV resource as a regular file system

HOMEPAGE = http://savannah.nongnu.org/projects/davfs2
LICENSE  = GPLv3

export ssbindir=$(STAGING_INSTALL_PREFIX)/sbin/
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-neon=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES) ppc853x hi3535),$(ARCH))
# patch Makefile.in for gcc -lt 4.9
# see https://savannah.nongnu.org/bugs/?51004
POST_CONFIGURE_TARGET = davfs2_post_configure
endif


include ../../mk/spksrc.cross-cc.mk

.PHONY: davfs2_post_configure
davfs2_post_configure:
	@$(RUN) sed -e "s#-fstack-protector-strong#-fstack-protector-all#g" -i src/Makefile.in
