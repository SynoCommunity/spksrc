PKG_NAME = x265
PKG_VERS = 1.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://bitbucket.org/multicoreware/x265/downloads
PKG_DIR = $(PKG_NAME)_$(PKG_VERS)/source
DEPENDS = cross/libnuma

HOMEPAGE = http://x265.org/
COMMENT  = x265 is an open source HEVC encoder.
LICENSE  = GPL

CONFIGURE_TARGET = myConf

include ../../mk/spksrc.cross-cc.mk


myConf:
	$(RUN) cmake -DCMAKE_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX) -DEXTRA_LINK_FLAGS="-ldl" .


ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
ADDITIONAL_CFLAGS = -O0
CONFIGURE_ARGS += --disable-asm
endif

ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --disable-asm
endif

ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --disable-asm
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += AS=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
endif

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += AS=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
endif

