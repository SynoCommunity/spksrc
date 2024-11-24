PKG_NAME = binutils
PKG_VERS = 2.42
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/binutils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/mpfr

# c++11 compiler is required (the real check is in cross/binutils/Makefile)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU Binutils
LICENSE  = GPLv2/LGPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --enable-host-shared
CONFIGURE_ARGS += --with-system-zlib
CONFIGURE_ARGS += --enable-gold=yes

include ../../mk/spksrc.archs.mk

# gprofng fails to build for i686 
# ./../common/core_pcbe.c:2698:33: error: ‘PERF_COUNT_HW_REF_CPU_CYCLES’ undeclared here
# gprofng is not built for other 32-bit archs
ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-gprofng
PLIST_TRANSFORM = sed -e '/bin\/gprofng/d' -e '/bin\/gp\-/d' -e '/lib\/gprofng/d'
endif

# Avoid conflicts with gdb
CONFIGURE_ARGS += --includedir=$(INSTALL_PREFIX)/include/binutils

ADDITIONAL_CXXFLAGS = -std=c++11

include ../../mk/spksrc.cross-cc.mk
