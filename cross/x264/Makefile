PKG_NAME = x264
PKG_VERS = 20190109-2245-stable
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-snapshot-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.videolan.org/x264/snapshots
PKG_DIR = $(PKG_NAME)-snapshot-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.videolan.org/developers/x264.html
COMMENT  = x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC forma
LICENSE  = GPLv2

GNU_CONFIGURE = 1

# YASM_PATH = $(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin
NASM_PATH = $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin

CONFIGURE_ARGS = --enable-shared --prefix=$(INSTALL_PREFIX) --enable-pic --cross-prefix=$(TC_PATH)$(TC_PREFIX)

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(ARM5_ARCHES) $(ARM7_ARCHES)),$(ARCH))
ENV += x264_ARCH=ARM
CONFIGURE_ARGS += --disable-asm
endif

ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
ENV += x264_ARCH=aarch64
CONFIGURE_ARGS += --disable-asm --host=arm-linux
endif

ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
ENV += x264_ARCH=PPC
CONFIGURE_ARGS += --disable-asm
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += AS=$(NASM_PATH)/nasm
ENV += PATH=$(NASM_PATH):$$PATH
ENV += x264_ARCH=X86_64
endif

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += AS=$(NASM_PATH)/nasm
ENV += PATH=$(NASM_PATH):$$PATH
ENV += x264_ARCH=X86
endif
