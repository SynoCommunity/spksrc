PKG_NAME = x264
PKG_VERS = 20240512-stable
PKG_EXT = tar.gz
PKG_GIT_HASH = 4613ac3c15fd75cebc4b9f65b7fb95e70a3acce1
PKG_DIST_NAME = $(PKG_NAME)-master.$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://code.videolan.org/videolan/x264/-/archive/$(PKG_GIT_HASH)
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

DEPENDS =
OPTIONAL_DEPENDS = native/nasm

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
BUILD_DEPENDS = native/nasm
NASM_PATH = $(abspath $(PWD)/../../native/nasm/work-native/install/usr/local/bin)
ENV += AS=$(NASM_PATH)/nasm
ENV += PATH=$(NASM_PATH):$$PATH
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
ENV += x264_ARCH=X86_64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
ENV += x264_ARCH=X86
endif
