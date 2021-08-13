PKG_NAME = xtrans
PKG_VERS = 1.3.5
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xorg-x11-util-macros

HOMEPAGE = https://www.x.org
COMMENT  = X.Org X11 developmental X transport library
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --datarootdir=$$INSTALL_PREFIX/lib

ifeq ($(findstring $(ARCH), ppc824x ppc853x),$(ARCH))
ifneq (5,$(firstword $(sort $(TCVERSION) 5)))
# toolchains before version 5 require the old linux quota version
# related issue: https://github.com/transmission/transmission/issues/591
ADDITIONAL_CFLAGS = -D_LINUX_QUOTA_VERSION=1
endif
endif
PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk
