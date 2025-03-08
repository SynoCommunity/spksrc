PKG_NAME = davfs2
PKG_VERS = 1.7.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/alisarctl/davfs2/releases/download/rel-$(subst .,-,$(PKG_VERS))

DEPENDS = cross/neon cross/libtool

DESCRIPTION = Mount a WebDAV resource as a regular file system
HOMEPAGE = https://savannah.nongnu.org/projects/davfs2
LICENSE  = GPLv3

export ssbindir=$(STAGING_INSTALL_PREFIX)/sbin/
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-neon=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.common.mk

# patch Makefile.in for gcc -lt 4.9
# see https://savannah.nongnu.org/bugs/?51004
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
POST_CONFIGURE_TARGET = davfs2_post_configure
endif
ifeq ($(call version_lt,${TCVERSION},6.0)$(call version_gt,${TCVERSION},2.0),11)
POST_CONFIGURE_TARGET = davfs2_post_configure
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: davfs2_post_configure
davfs2_post_configure:
	@$(MSG) Patch Makefile.in for older gcc
	@$(RUN) sed -e "s#-fstack-protector-strong#-fstack-protector-all#g" -i src/Makefile.in
