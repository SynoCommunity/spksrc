PKG_NAME = libblkid
PKG_REAL_NAME = util-linux
PKG_VERS = 2.41.1
PKG_VERS_MAJOR = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/linux/utils/util-linux/v$(PKG_VERS_MAJOR)
# use dedicated folder to build independent of other libraries built from util-linux (i.e. libuuid, libmount, libblkid)
PKG_DIR = $(PKG_NAME)/$(PKG_REAL_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)

DEPENDS =

HOMEPAGE = https://github.com/util-linux/util-linux/
COMMENT  = Random collection of Linux utilities. We use this only to build libblkid out of util-linux.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --without-ncurses --without-python --disable-asciidoc
# Create libblkid only
CONFIGURE_ARGS += --disable-all-programs --enable-libblkid

ADDITIONAL_CFLAGS = -O -Wno-unused-parameter

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
ifeq ($(call version_lt, $(TCVERSION), 7.2),1) 
CONFIGURE_ARGS += --disable-year2038
endif
endif

include ../../mk/spksrc.cross-cc.mk
