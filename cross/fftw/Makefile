PKG_NAME = fftw
PKG_VERS = 3.3.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://fftw.org
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://fftw.org/index.html
COMMENT  = FFTW is a C subroutine library for computing the discrete Fourier transform (DFT) in one or more dimensions, of arbitrary input size, and of both real and complex data (as well as of even/odd data, i.e. the discrete cosine/sine transforms or DCT/DST).
LICENSE  = GNU General Public License

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --enable-shared
CONFIGURE_ARGS += --disable-doc

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-neon
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-sse2
endif

include ../../mk/spksrc.cross-cc.mk
