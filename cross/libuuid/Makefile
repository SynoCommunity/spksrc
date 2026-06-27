PKG_NAME = libuuid
PKG_REAL_NAME = util-linux
PKG_VERS = 2.41.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/linux/utils/util-linux/v$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
# use dedicated folder to build independent of other libraries built from util-linux (i.e. ionice, libblkid, libmount, libuuid, misc-util-linux)
PKG_DIR = $(PKG_NAME)/$(PKG_REAL_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)

DEPENDS =

HOMEPAGE = https://github.com/util-linux/util-linux/
COMMENT  = Random collection of Linux utilities. We use this only to build libuuid out of util-linux.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --without-ncurses
CONFIGURE_ARGS += --without-python
CONFIGURE_ARGS += --disable-static
# We use libuuid only
CONFIGURE_ARGS += --disable-all-programs --enable-libuuid

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# optimization "-O" fails with older toolchains 
# assembler Error: invalid operands (.text and *UND* sections)
ADDITIONAL_CFLAGS = -O2
else
ADDITIONAL_CFLAGS = -O
endif

ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
ifeq ($(call version_lt, $(TCVERSION), 7.2),1) 
CONFIGURE_ARGS += --disable-year2038
endif
endif

include ../../mk/spksrc.cross-cc.mk
