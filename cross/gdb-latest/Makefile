PKG_NAME = gdb
PKG_VERS = 13.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/gdb
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libexpat cross/gmp cross/ncursesw cross/mpfr

HOMEPAGE = https://www.gnu.org/software/gdb/
COMMENT  = The GNU Project Debugger.
LICENSE  = GPLv2/LGPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --enable-host-shared
CONFIGURE_ARGS += --with-system-zlib

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

include ../../mk/spksrc.cross-cc.mk

# Library is not created for armv5 and armv7
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
PLIST_TRANSFORM = sed -e 's?lib:lib/libinproctrace.so??g'
endif

ifneq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
# binary only created for arm
PLIST_TRANSFORM = sed -e 's?bin:bin/run??g'
endif
