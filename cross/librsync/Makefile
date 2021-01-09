PKG_NAME = librsync
PKG_VERS = 2.3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/librsync/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/popt cross/zlib cross/bzip2

HOMEPAGE = http://librsync.sourcefrog.net
COMMENT  = remote delta-compression library.
LICENSE  = LPGL-2.1

CONFIGURE_TARGET = librsync_configure

CMAKE_ARGS += -D CMAKE_BUILD_TYPE=Release
CMAKE_ARGS += -D CMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -D CMAKE_CROSSCOMPILING=true
CMAKE_ARGS += -D CMAKE_SYSTEM_NAME=Linux
CMAKE_ARGS += -D CMAKE_C_COMPILER=$(TC_PATH)$(TC_PREFIX)gcc
CMAKE_ARGS += -D BZIP2_LIBRARIES=$(STAGING_INSTALL_PREFIX)/lib
CMAKE_ARGS += -D ZLIB_LIBRARY=$(STAGING_INSTALL_PREFIX)/lib
CMAKE_ARGS += -Wno-dev

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CMAKE_ARGS += -D CMAKE_SYSTEM_PROCESSOR=armv5
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CMAKE_ARGS += -D CMAKE_SYSTEM_PROCESSOR=armv7
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CMAKE_ARGS += -D CMAKE_SYSTEM_PROCESSOR=x86_64
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CMAKE_ARGS += -D CMAKE_SYSTEM_PROCESSOR=i686
endif
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CMAKE_ARGS += -D CMAKE_SYSTEM_PROCESSOR=aarch64
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CMAKE_ARGS += -D CMAKE_SYSTEM_PROCESSOR=ppc
endif

.PHONY: librsync_configure
librsync_configure:
	$(RUN) cmake CMakeLists.txt $(CMAKE_ARGS)
