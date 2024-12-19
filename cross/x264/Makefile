PKG_NAME = x264
PKG_VERS = 20240512-stable
PKG_EXT = tar.gz
PKG_GIT_HASH = 4613ac3c15fd75cebc4b9f65b7fb95e70a3acce1
PKG_DIST_NAME = $(PKG_NAME)-master.$(PKG_EXT)
PKG_DIST_SITE = https://code.videolan.org/videolan/x264/-/archive/$(PKG_GIT_HASH)
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

DEPENDS =

# configure fails in "endian test"
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.videolan.org/developers/x264.html
COMMENT  = x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC forma
LICENSE  = GPLv2

# configure with "GNU_CONFIGURE = 1" complains: "Unknown option --build=i686-pc-linux, ignored"
CONFIGURE_ARGS  = --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --disable-opencl

include ../../mk/spksrc.cross-cc.mk

CONFIGURE_ARGS += --host=$(TC_TARGET)

# Define x86asm or use gcc as assembler
ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
NASM_BINARY = $(shell which nasm)
ifeq ($(NASM_BINARY),)
$(error nasm not found. Please install NASM assembler)
endif
ENV += AS=$(NASM_BINARY)
else
# Expects to be assembled with a C compiler as frontend
# .s is raw assembly passed to as
# .S is assembly which expects to be preprocessed by a cpp then fed to assembler
# More info: https://code.videolan.org/videolan/x264/-/issues/61
ENV += AS=$(TC_PATH)$(TC_PREFIX)gcc
endif

ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
ENV += x264_ARCH=ARM
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
ENV += x264_ARCH=PPC
CONFIGURE_ARGS += --disable-asm
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
ENV += x264_ARCH=X86_64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
ENV += x264_ARCH=X86
endif
