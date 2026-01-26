PKG_NAME = x264
PKG_VERS = 20250608-stable
PKG_EXT = tar.gz
PKG_GIT_HASH = b35605ace3ddf7c1a5d67a2eb553f034aef41d55
PKG_DIST_NAME = $(PKG_NAME)-master.$(PKG_EXT)
PKG_DIST_SITE = https://code.videolan.org/videolan/x264/-/archive/$(PKG_GIT_HASH)
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = https://www.videolan.org/developers/x264.html
COMMENT  = x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC forma
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --enable-shared
CONFIGURE_ARGS += --enable-pic
CONFIGURE_ARGS += --disable-opencl
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --cross-prefix=$(TC_PATH)$(TC_PREFIX)

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
ENV += x264_ARCH=ARM
CONFIGURE_ARGS += --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
ENV += x264_ARCH=ARM
CONFIGURE_ARGS += --host=aarch64-linux
# Expects to be assembled with a C compiler as frontend
# .s is raw assembly passed to as
# .S is assembly which expects to be preprocessed by a cpp then fed to assembler
# More info: https://code.videolan.org/videolan/x264/-/issues/61
ENV += AS=$(abspath $(PWD)/../../toolchain/syno-$(ARCH)-$(TCVERSION)/work/$(TC_TARGET)/bin/$(TC_PREFIX)gcc)
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
ENV += x264_ARCH=PPC
CONFIGURE_ARGS += --disable-asm
endif

# Define x86asm
ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
ENV += AS=$(shell which nasm)
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
ENV += x264_ARCH=X86_64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
ENV += x264_ARCH=X86
endif
