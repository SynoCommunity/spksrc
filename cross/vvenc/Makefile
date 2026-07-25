PKG_NAME = vvenc
PKG_VERS = 1.14.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/fraunhoferhhi/vvenc/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.hhi.fraunhofer.de/en/departments/vca/technologies-and-solutions/h266-vvc.html
COMMENT  = VVenC, the Fraunhofer Versatile Video Encoder, is a fast and efficient software H.266/VVC encoder implementation
LICENSE  = BSD-3-Clause-Clear license

# Needs gcc >= 7.5: needs C++17, i.e. gcc 7 or newer.
MIN_GCC_VERSION = 7.5

# Build libvvenc only. The test executables (vvencinterfacetest and friends) link
# with the C driver -- their source is .c -- so cmake picks C as the link language
# and omits libstdc++, then fails on the C++ symbols they pull from libvvenc:
#   vvencinterfacetest: undefined reference to `operator delete(void*, ...)@CXXABI'
# ffmpeg depends on libvvenc, never on these binaries, so there is nothing to lose.
CONFIGURE_ARGS += -DVVENC_LIBRARY_ONLY=ON

include ../../mk/spksrc.common.mk

# ARMv5 has no NEON at all, and neither ARMv7L (hi3535) nor the ARMv7 targets we
# build for can be relied on to have it, so vvenc's ARM SIMD path does not compile
# there ("'abs_hi' was not declared in this scope" out of arm/neon/MCTF_neon.cpp).
# ARMv8 keeps it: NEON is mandatory in that baseline.
#
# ARMv5 and ARMv7L were missing here simply because vvenc was never built for them
# -- they were excluded wholesale before this could show.
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -DVVENC_ENABLE_ARM_SIMD=FALSE
endif

# vvenc's detect_target_architecture knows ARM/AARCH64/X86/LOONGARCH but not PowerPC,
# so on PPC it leaves VVENC_ENABLE_X86_SIMD at its default TRUE and tries to compile
# x86/sse41 and x86/avx2 -- which crashes the PPC gcc with an ICE. No PPC SIMD path
# exists, so build scalar.
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -DVVENC_ENABLE_X86_SIMD=FALSE
endif

include ../../mk/spksrc.cross-cmake.mk
