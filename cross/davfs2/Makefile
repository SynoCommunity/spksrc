PKG_NAME = davfs2
PKG_VERS = 1.6.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.savannah.gnu.org/releases/davfs2

DEPENDS = cross/neon cross/libtool
DESCRIPTION = Mount a WebDAV resource as a regular file system

HOMEPAGE = https://savannah.nongnu.org/projects/davfs2
LICENSE  = GPLv3

export ssbindir=$(STAGING_INSTALL_PREFIX)/sbin/
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-neon=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# patch Makefile.in for gcc -lt 4.9
# see https://savannah.nongnu.org/bugs/?51004
POST_CONFIGURE_TARGET = davfs2_post_configure
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: davfs2_post_configure
davfs2_post_configure:
	@$(RUN) sed -e "s#-fstack-protector-strong#-fstack-protector-all#g" -i src/Makefile.in
