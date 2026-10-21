PKG_NAME = libmount
PKG_REAL_NAME = util-linux
PKG_VERS = 2.42.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/linux/utils/util-linux/v$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
# use dedicated folder to build independent of other libraries built from util-linux (i.e. ionice, libblkid, libmount, libuuid, misc-util-linux)
PKG_DIR = $(PKG_NAME)/$(PKG_REAL_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)

DEPENDS =

# glibc 2.8 has no O_PATH (added in 2.14):
#   libmount/src/context_umount.c:294: 'O_PATH' undeclared
MIN_GLIBC_VERSION = 2.14

HOMEPAGE = https://github.com/util-linux/util-linux/
COMMENT  = Random collection of Linux utilities. We use this only to build libmount out of util-linux.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --without-ncurses --without-python --disable-asciidoc
# Create libmount only (libblkid is needed for libmount)
CONFIGURE_ARGS += --disable-all-programs --enable-libmount --enable-libblkid

ADDITIONAL_CFLAGS = -O -Wno-unused-parameter

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
ifeq ($(call version_lt, $(TCVERSION), 7.2),1) 
CONFIGURE_ARGS += --disable-year2038
endif
endif

include ../../mk/spksrc.cross-cc.mk
