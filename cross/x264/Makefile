PKG_NAME = x264
PKG_VERS = 20210107-stable
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 0d754ec36013fee82978496cd56fbd48824910b3
PKG_DIST_SITE = https://github.com/mirror/x264.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS =
OPTIONAL_DEPENDS = native/nasm

HOMEPAGE = https://www.videolan.org/developers/x264.html
COMMENT  = x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC forma
LICENSE  = GPLv2

GNU_CONFIGURE = 1

# YASM_PATH = $(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin
NASM_PATH = $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin

CONFIGURE_ARGS = --enable-shared --prefix=$(INSTALL_PREFIX) --enable-pic --cross-prefix=$(TC_PATH)$(TC_PREFIX)

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
ENV += x264_ARCH=ARM
CONFIGURE_ARGS += --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
ENV += x264_ARCH=aarch64
CONFIGURE_ARGS += --disable-asm --host=arm-linux
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
ENV += x264_ARCH=PPC
CONFIGURE_ARGS += --disable-asm
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
DEPENDS += native/nasm
ENV += AS=$(NASM_PATH)/nasm
ENV += PATH=$(NASM_PATH):$$PATH
ENV += x264_ARCH=X86_64
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
DEPENDS += native/nasm
ENV += AS=$(NASM_PATH)/nasm
ENV += PATH=$(NASM_PATH):$$PATH
ENV += x264_ARCH=X86
endif
