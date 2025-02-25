PKG_NAME = numpy
PKG_VERS = 2.2.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/n/numpy
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://numpy.org/
COMMENT  = NumPy is the fundamental package for scientific computing with Python.
LICENSE  = NumPy Developers

# Requires gcc>=8.4 to build sucesfully
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

MESON_PYTHON = 1

include ../../mk/spksrc.common.mk

# Compiler segfault using gcc-8.5 (althoug working with gcc-12.2)
# success using following CFLAGS:
#     -fno-tree-vectorize
#     -fno-tree-loop-vectorize (less impactfull on optizations)
ifeq ($(call version_le, $(TCVERSION), 7.1),1)
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
#ADDITIONAL_CFLAGS = -DNPY_HAVE_NEON_VFPV4=0 -DNPY_HAVE_NEON_FP16=0 -DNPY_HAVE_NEON=0 -DNPY_HAVE_ASIMD=0
#ADDITIONAL_CFLAGS = -march=armv8-a+nosimd
#ADDITIONAL_CFLAGS = -DNPY_DISABLE_CPU_FEATURES=ASIMD,NEON
#ADDITIONAL_CFLAGS = -mno-neon -mno-simd
#ADDITIONAL_CFLAGS = -DNPY_HAVE_NEON=0 -DNPY_HAVE_ASIMD=0
#ADDITIONAL_CFLAGS = -DVQSORT_ENABLED=0
#ADDITIONAL_CFLAGS = -mno-outline-atomics
#ADDITIONAL_CFLAGS = -O0 -fno-fast-math -fno-tree-vectorize
ADDITIONAL_CFLAGS = -fno-tree-loop-vectorize
#ADDITIONAL_CXXFLAGS = -fno-tree-loop-vectorize
#ADDITIONAL_CPPFLAGS = -fno-tree-loop-vectorize
#ADDITIONAL_CFLAGS = -O3 -fno-fast-math -fno-tree-vectorize
#ENV += NPY_CPU_BASELINE="none" NPY_CPU_DISPATCH=""
endif
endif

include ../../mk/spksrc.python-wheel-meson.mk
