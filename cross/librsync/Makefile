PKG_NAME = librsync
PKG_VERS = 2.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/librsync/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/popt

HOMEPAGE = https://github.com/librsync/$(PKG_NAME)
COMMENT  = librsync is a free software library that implements the rsync remote-delta algorithm
LICENSE  =

CONFIGURE_TARGET = librsync_configure
INSTALL_TARGET = librsync_install

include ../../mk/spksrc.cross-cc.mk

CMAKE_ARGS = \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) \
	-DCMAKE_CROSSCOMPILING=TRUE \
	-DCMAKE_SYSTEM_NAME=Linux \
	-DCMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc \
	-DCMAKE_C_FLAGS="-std=gnu99" \
	-DCMAKE_EXE_LINKER_FLAGS="-L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -Wl,--rpath-link,$(INSTALL_DIR)$(INSTALL_PREFIX)/lib -Wl,--rpath,$(INSTALL_PREFIX)/lib" \
	-DCMAKE_FIND_ROOT_PATH=$(INSTALL_DIR)$(INSTALL_PREFIX) \
	-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
	-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
	-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
	-DBUILD_RDIFF=yes \
	$(NULL)

ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv5
endif

ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-fPIC
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=armv7
endif

ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-fPIC
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=aarch64
endif

ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=ppc64
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86_64
endif

ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
CMAKE_ARGS += -DCMAKE_SYSTEM_PROCESSOR=x86
endif

.PHONY: librsync_configure
librsync_configure:
	$(RUN) cmake $(CMAKE_ARGS)

.PHONY: librsync_install
librsync_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
