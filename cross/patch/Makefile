PKG_NAME = patch
PKG_VERS = 2.8
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/patch
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/attr

HOMEPAGE = https://savannah.gnu.org/projects/patch/
COMMENT  = Patch takes a patch file containing a difference listing produced by the diff program and applies those differences to one or more original files, producing patched versions.
LICENSE  = GPLv3+

GNU_CONFIGURE = 1

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
ifeq ($(call version_lt, $(TCVERSION), 7.2),1) 
CONFIGURE_ARGS += --disable-year2038
endif
endif

include ../../mk/spksrc.cross-cc.mk
