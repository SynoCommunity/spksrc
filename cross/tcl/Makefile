PKG_NAME = tcl
PKG_VERS = 8.6.10
PKG_MAIN_VERS=$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = https://prdownloads.sourceforge.net/tcl/
PKG_DIR = $(PKG_NAME)$(PKG_VERS)/unix

DEPENDS =

HOMEPAGE = https://www.tcl.tk/
COMMENT  = Tcl (Tool Command Language) is a very powerful but easy to learn dynamic programming language, suitable for a very wide range of uses, including web and desktop applications, networking, administration, testing and many more. Open source and business-friendly, Tcl is a mature yet evolving language that is truly cross platform, easily deployed and highly extensible.
LICENSE  = https://tcl.tk/software/tcltk/license.html

GNU_CONFIGURE = 1

include ../../mk/spksrc.archs.mk

# Enable 64-bit support in Tcl for x64 architectures
# aarch64 does not support 64-bit (don't know magic for this platform)
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
  CONFIGURE_ARGS = --enable-64bit
endif

POST_INSTALL_TARGET = tcl_post_install

include ../../mk/spksrc.cross-cc.mk

# Create a symlink libtcl so that any other packages which are compiled by
# spksrc may link to a library without a version number in the filename
.PHONY: tcl_post_install
tcl_post_install:
	$(RUN) ln -s -r $(STAGING_INSTALL_PREFIX)/lib/libtcl$(PKG_MAIN_VERS).so $(STAGING_INSTALL_PREFIX)/lib/libtcl.so
