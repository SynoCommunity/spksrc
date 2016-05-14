PKG_NAME = x264
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = stable
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://git.videolan.org/git/x264.git
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = http://www.videolan.org/developers/x264.html
COMMENT  = x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC forma
LICENSE  =

PRE_DOWNLOAD_TARGET = eraseDownload

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


.PHONY: eraseDownload
eraseDownload:
	@rm -f $(DISTRIB_DIR)/$(PKG_DIST_FILE)
