PKG_NAME = OpenBLAS
PKG_VERS = 0.3.29
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenMathLib/OpenBLAS/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.openblas.net/
COMMENT  = OpenBLAS is an optimized BLAS (Basic Linear Algebra Subprograms) library based on GotoBLAS2 1.13 BSD version.
LICENSE  = BSD-3-Clause license

REQUIRED_MIN_DSM = 7.1

CMAKE_ARGS  = -DNO_LAPACKE=1
CMAKE_ARGS += -DNO_AFFINITY=1
CMAKE_ARGS += -DNO_WARMUP=1
CMAKE_ARGS += -DNUM_THREADS=64
CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON
CMAKE_ARGS += -DBUILD_TESTING=OFF

include ../../mk/spksrc.common.mk

# From Debian rule file:
# We cannot use the ARMv7 profile on armhf, because it requires a 32-register FP unit.
# See kernel/arm/KERNEL.ARMv7: it loads some *_vfpv3.S files, which use 32 registers.
# Also, it FTBFS if GCC flag -mvfpv3 is removed (see arm-gcc-flags.patch), because GCC
# refuses asm files with 32 FP registers in that case.
# Issue discussed in https://github.com/OpenMathLib/OpenBLAS/issues/388
# See also debian/patches/arm-gcc-flags.patch which is related.
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CMAKE_ARGS += -DTARGET=ARMV6
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -DTARGET=ARMV8
endif

# Options are: HASWELL (recent), SANDYBRIDGE (older), NEHALEM (most compatible)
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -DTARGET=SANDYBRIDGE
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CMAKE_ARGS += -DTARGET=ATOM
endif

ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -DBINARY=64
else
CONFIGURE_ARGS += -DBINARY=32
endif

include ../../mk/spksrc.cross-cmake.mk
