PKG_NAME = zip
PKG_VERS = 3.00
PKG_SHORTVERS = 30
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_SHORTVERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/infozip/files/Zip%203.x%20%28latest%29/3.0
PKG_DIR = $(PKG_NAME)$(PKG_SHORTVERS)

DEPENDS = cross/bzip2

HOMEPAGE = http://infozip.sourceforge.net/Zip.html
COMMENT  = A file compression and packaging utility compatible with PKZIP
LICENSE  = BSD


ifeq ($(findstring $(ARCH), ppc824x ppc853x),$(ARCH))
ifneq (5,$(firstword $(sort $(TCVERSION) 5)))
# toolchains before version 5 require the old linux quota version
# related issue: https://github.com/transmission/transmission/issues/591
ADDITIONAL_CFLAGS = -D_LINUX_QUOTA_VERSION=1
endif
endif
PATCHES_LEVEL = 1
CONFIGURE_TARGET = nop
COMPILE_TARGET = $(PKG_NAME)_compile_target
INSTALL_TARGET = $(PKG_NAME)_install_destdir_target

include ../../mk/spksrc.cross-cc.mk

.PHONY: $(PKG_NAME)_compile_target
$(PKG_NAME)_compile_target:
	@$(RUN) $(MAKE) -f unix/Makefile generic_gcc CFLAGS_NOOPT="-I. -DUNIX" 

.PHONY: $(PKG_NAME)_install_destdir_target
$(PKG_NAME)_install_destdir_target:
	$(RUN) $(MAKE) -f unix/Makefile install prefix=$(INSTALL_DIR)$(INSTALL_PREFIX)
