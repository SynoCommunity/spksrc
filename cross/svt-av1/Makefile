PKG_NAME = SVT-AV1
PKG_VERS = 2.3.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/OpenVisualCloud/SVT-AV1
COMMENT  = The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder) is an AV1-compliant encoder/decoder library core.
LICENSE  = SPDX short identifier: BSD-2-Clause-Patent

# Avoids ffmpeg to fail detecting SVT-AV1 on unresolved math synbols
ADDITIONAL_LDFLAGS =  -lm
POST_INSTALL_TARGET = svt-av1_post_install_target

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

include ../../mk/spksrc.cross-cmake.mk

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
ifeq ($(call version_lt, ${TC_GCC}, 5),1)
CMAKE_ARGS += -DCOMPILE_C_ONLY=ON
endif
endif

# GCC 4.9 has incomplete/broken AVX-512 intrinsics support
ifeq ($(call version_lt, ${TC_GCC}, 5.0),1)
  CMAKE_ARGS += -DENABLE_AVX512=OFF
endif

.PHONY: svt-av1_post_install_target
svt-av1_post_install_target:
	$(RUN) sed -i 's|^prefix=.*|prefix=$(STAGING_INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/SvtAv1Enc.pc
