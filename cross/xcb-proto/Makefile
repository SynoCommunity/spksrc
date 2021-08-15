PKG_NAME = xcb-proto
PKG_VERS = 1.14.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.x.org/archive/individual/proto
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.x.org
COMMENT  = XCB protocol descriptions
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


include ../../mk/spksrc.cross-cc.mk
