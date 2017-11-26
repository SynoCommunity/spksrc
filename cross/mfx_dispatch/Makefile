PKG_NAME = mfx_dispatch
PKG_VERS = 
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.intel.com
PKG_DIR = $(PKG_NAME)$(PKG_VERS)

DEPENDS = cross/libva

HOMEPAGE = http://www.intel.com
COMMENT  = 
LICENSE  = GPL

CONFIGURE_TARGET = myConfigure
#POST_INSTALL_TARGET = myInstall

YASM_PATH = $(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin

include ../../mk/spksrc.cross-cc.mk

CMAKE_ARGS  = -DCMAKE_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX)
CMAKE_ARGS += -DEXTRA_LINK_FLAGS="-ldl"
CMAKE_ARGS += -DCMAKE_CROSSCOMPILING=TRUE
CMAKE_ARGS += -DCMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -DCMAKE_CXX_COMPILER=$(TC_PATH)$(TC_PREFIX)g++

CONFIGURE_ARGS = INSTALL_PREFIX=" "

UNSUPPORTED_ARCHS = $(PPC_ARCHES)

ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv5
endif

ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-fPIC
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv7
endif

ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=ppc64
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
ENV += PATH=$(YASM_PATH):$$PATH
CMAKE_ARGS += -D__ARCH:STRING=intel64
CMAKE_ARGS += -D__PREFIX_DIR=$(INSTALL_PREFIX)
endif

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
DEPENDS += native/yasm cross/libnuma
ENV += PATH=$(YASM_PATH):$$PATH
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86
endif

# For ppc853x-4.3, disable atomics
ifeq ($(ARCH)-$(TCVERSION), ppc853x-4.3)
CMAKE_ARGS += -DNO_ATOMICS=ON
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-DSPKSRC_FIX_PPC853X_4_3"
endif

.PHONY: myConfigure
myConfigure:
	$(RUN) cmake $(CMAKE_ARGS) .

#.PHONY: myInstall
#myInstall:
#	mv $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/mfx.pc $(STAGING_INSTALL_DIR)/lib/pkgconfig/libmfx.pc
