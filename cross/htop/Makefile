PKG_NAME = htop
PKG_VERS = 3.4.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/htop-dev/htop/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://hisham.hm/htop/
COMMENT  = An interactive process viewer for Linux.
LICENSE  = GPLv2+

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-unicode

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# use clock_gettime of librt
ADDITIONAL_LDFLAGS = -lrt
endif

include ../../mk/spksrc.cross-cc.mk
