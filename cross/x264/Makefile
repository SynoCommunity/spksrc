PKG_NAME = x264
PKG_VERS = 20160320-2245
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-snapshot-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.videolan.org/pub/x264/snapshots/
PKG_DIR = $(PKG_NAME)-snapshot-$(PKG_VERS)
DEPENDS =

HOMEPAGE = http://www.videolan.org/developers/x264.html
COMMENT  = x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC forma
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-static --prefix=$(INSTALL_PREFIX) --enable-pic --cross-prefix=$(TC_PATH)$(TC_PREFIX)

include ../../mk/spksrc.cross-cc.mk


ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
ADDITIONAL_CFLAGS = -O0
CONFIGURE_ARGS += --disable-asm
ENV += x264_ARCH=ARM
endif

ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --disable-asm
ENV += x264_ARCH=ARM
endif

ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --disable-asm
ENV += x264_ARCH=PPC
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += AS=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
ENV += x264_ARCH=X86_64
endif

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += AS=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
ENV += x264_ARCH=X86
endif
