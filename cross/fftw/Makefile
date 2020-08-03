PKG_NAME = fftw
PKG_VERS = 3.3.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.fftw.org
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.fftw.org/
COMMENT  = FFTW is a C subroutine library for computing the discrete Fourier transform (DFT) in one or more dimensions, of arbitrary input size, and of both real and complex data (as well as of even/odd data, i.e. the discrete cosine/sine transforms or DCT/DST).
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared --enable-float --enable-threads

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --enable-neon --enable-armv7a-cntvct --enable-armv7a-pmccntr
endif

ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --enable-neon --enable-armv8-pmccntr-el0 --enable-armv8-cntvct-el0
endif

ifeq ($(findstring $(ARCH),x64_ARCHES),$(ARCH))
CONFIGURE_ARGS += --enable-sse --enable-sse2
CONFIGURE_ARGS += --enable-avx --enable-avx2 --enable-avx512 --enable-avx-128-fma
endif
