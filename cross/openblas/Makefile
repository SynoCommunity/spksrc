PKG_NAME = OpenBLAS
PKG_VERS = 0.3.29
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenMathLib/OpenBLAS/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.openblas.net/
COMMENT  = OpenBLAS is an optimized BLAS (Basic Linear Algebra Subprograms) library based on GotoBLAS2 1.13 BSD version.
LICENSE  = 3-Clause BSD

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

CMAKE_ARGS  = -DBUILD_SHARED_LIBS=ON
# numpy uses very slow internal functions when BLAS and LAPACK are not available.
CMAKE_ARGS += -DBUILD_WITHOUT_LAPACK=OFF
CMAKE_ARGS += -DBUILD_TESTING=OFF

ADDITIONAL_CFLAGS  = -Wno-unused-variable
ADDITIONAL_CFLAGS += -Wno-unused-function
ADDITIONAL_CFLAGS += -Wno-maybe-uninitialized
ADDITIONAL_CFLAGS += -Wno-parentheses

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
# From Debian rule file:
# We cannot use the ARMv7 profile on armhf, because it requires a 32-register FP unit.
# See kernel/arm/KERNEL.ARMv7: it loads some *_vfpv3.S files, which use 32 registers.
# Also, it FTBFS if GCC flag -mvfpv3 is removed (see arm-gcc-flags.patch), because GCC
# refuses asm files with 32 FP registers in that case.
# Issue discussed in https://github.com/OpenMathLib/OpenBLAS/issues/388
# See also debian/patches/arm-gcc-flags.patch which is related.
ifeq ($(call version_ge, $(TC_GCC), 4.9),1)
CMAKE_ARGS += -DTARGET=ARMV6
else
# completly disable use of vpf
CMAKE_ARGS += -DTARGET=ARMV5
endif
endif

ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
CMAKE_ARGS += -DTARGET=ARMV5
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DTARGET=ARMV8
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
# most of the x64 ARCHS are atom SoC types (Pineview, Cedarview, Braswell, Denverton, Apollolake)
CMAKE_ARGS += -DTARGET=ATOM
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CMAKE_ARGS += -DTARGET=ATOM
endif

ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
CMAKE_ARGS += -DBINARY=64
else
CMAKE_ARGS += -DBINARY=32
endif

include ../../mk/spksrc.cross-cmake.mk
