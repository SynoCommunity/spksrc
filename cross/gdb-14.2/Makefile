PKG_NAME = gdb
PKG_VERS = 14.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/gdb
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libexpat cross/gmp cross/ncursesw cross/mpfr

HOMEPAGE = https://www.gnu.org/software/gdb/
COMMENT  = The GNU Project Debugger.
LICENSE  = GPLv2/LGPLv2

# Needs gcc >= 4.8.1: C++11 features unavailable before, which is what the
# "UNSUPPORTED_ARCHS = $(ARCHS) if gcc < 4.8.1" below the includes used to say
MIN_GCC_VERSION = 4.8.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-host-shared
CONFIGURE_ARGS += --with-system-zlib

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# sim/ppc is broken
CONFIGURE_ARGS += --disable-sim
endif

PLIST_TRANSFORM_SED_ARGS =

# Library is not created for 32-bit non intel archs
ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
ifneq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PLIST_TRANSFORM_SED_ARGS += -e 's?lib:lib/libinproctrace.so??g'
endif
endif

ifneq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
# binary only created for arm
PLIST_TRANSFORM_SED_ARGS += -e 's?bin:bin/run??g'
endif

ifneq ($(strip $(PLIST_TRANSFORM_SED_ARGS)),)
PLIST_TRANSFORM = sed $(PLIST_TRANSFORM_SED_ARGS)
endif

include ../../mk/spksrc.cross-cc.mk
