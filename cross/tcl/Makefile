PKG_NAME = tcl
PKG_MAIN_VERS = 8.6
PKG_VERS = $(PKG_MAIN_VERS).10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = https://prdownloads.sourceforge.net/tcl/
PKG_DIR = $(PKG_NAME)$(PKG_VERS)/unix

DEPENDS =
BUILD_DEPENDS = cross/zlib

HOMEPAGE = https://www.tcl.tk/
COMMENT  = Tcl (Tool Command Language) is a very powerful but easy to learn dynamic programming language, suitable for a very wide range of uses, including web and desktop applications, networking, administration, testing and many more. Open source and business-friendly, Tcl is a mature yet evolving language that is truly cross platform, easily deployed and highly extensible.
LICENSE  = https://tcl.tk/software/tcltk/license.html

GNU_CONFIGURE = 1

# Enable 64-bit support in Tcl for 64-bit architectures
ifeq ($(findstring $(ARCH), $(x64_ARCHES) $(ARM8_ARCHES)),$(ARCH))
  CONFIGURE_ARGS = --enable-64bit
endif

POST_INSTALL_TARGET = tcl_custom_post_install

include ../../mk/spksrc.cross-cc.mk

# Create a symlink libtcl so that any other packages which are compiled by
# spksrc will link to a library without a version number in the filename
.PHONY: tcl_custom_post_install
tcl_custom_post_install:
	$(RUN) ln -s -r $(STAGING_INSTALL_PREFIX)/lib/libtcl$(PKG_MAIN_VERS).so $(STAGING_INSTALL_PREFIX)/lib/libtcl.so
