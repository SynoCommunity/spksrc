PKG_NAME = util-linux
PKG_VERS_MAJOR = 2.33
PKG_VERS_MINOR = 1
PKG_VERS = $(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/linux/utils/$(PKG_NAME)/v$(PKG_VERS_MAJOR)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/karelzak/util-linux
COMMENT  = Random collection of Linux utilities
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --without-ncurses --without-python
CONFIGURE_ARGS += --disable-all-programs --enable-libuuid

ifeq ($(findstring $(ARCH), hi3535),$(ARCH))
CONFIGURE_ARGS += --disable-schedutils
else
CONFIGURE_ARGS += --enable-schedutils
endif

include ../../mk/spksrc.cross-cc.mk
