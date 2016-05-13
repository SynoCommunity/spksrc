PKG_NAME = x265
PKG_VERS = 1.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://bitbucket.org/multicoreware/x265/downloads
PKG_DIR = $(PKG_NAME)_$(PKG_VERS)/source

DEPENDS =

HOMEPAGE = http://x265.org/
COMMENT  = x265 is an open source HEVC encoder.
LICENSE  = GPL

CONFIGURE_TARGET = myConf

include ../../mk/spksrc.cross-cc.mk


CMAKE=cmake -DCMAKE_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX) \
				-DEXTRA_LINK_FLAGS="-ldl" \
				-DCMAKE_CROSSCOMPILING=TRUE \
				-DCMAKE_SYSTEM_NAME=Linux \
				-DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc \
				-DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++


ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CMAKE += -DCMAKE_SYSTEM_PROCESSOR=armv5
endif

ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
CMAKE += -DCMAKE_CXX_FLAGS=-fPIC
CMAKE += -DCMAKE_SYSTEM_PROCESSOR=armv7
endif

ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
CMAKE += -DCMAKE_SYSTEM_PROCESSOR=ppc64
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += AS=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
DEPENDS += cross/libnuma
CMAKE += -DCMAKE_SYSTEM_PROCESSOR=x86_64
endif

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += AS=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
DEPENDS += cross/libnuma
CMAKE += -DCMAKE_SYSTEM_PROCESSOR=x86
endif


myConf:
	$(RUN) $(CMAKE) .

