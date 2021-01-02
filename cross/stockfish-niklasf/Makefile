PKG_NAME = Stockfish-fishnet
PKG_VERS = 20200613
PKG_EXT = tar.gz
PKG_DIST_NAME = fishnet-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/niklasf/Stockfish/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)/src

HOMEPAGE = https://lichess.org/get-fishnet
COMMENT  = Distributed Stockfish analysis for lichess.org.
LICENSE  = GPLv3

CONFIGURE_TARGET = nop
INSTALL_TARGET = Stockfish-fishnet_install

include ../../mk/spksrc.archs.mk

# Toolchains lacking c++11 compiler are not supported
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# use builtin atomic support
ADDITIONAL_LDFLAGS = -latomic
endif


include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
	BUILD_ARCH=arm64
endif
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
	BUILD_ARCH=armv7
endif
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
	BUILD_ARCH=x86-32
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
	BUILD_ARCH=x86-64
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
	BUILD_ARCH=ppc-32
endif

COMPILE_MAKE_OPTIONS = build ARCH=$(BUILD_ARCH)
ifeq (g++,$(CXX))
# workaround for: CXX not fully qualified when building in cross folder
COMPILE_MAKE_OPTIONS += COMPCXX=$(TC_PATH)$(TC_PREFIX)$(CXX)
else
COMPILE_MAKE_OPTIONS += COMPCXX=$(CXX)
endif

.PHONY: Stockfish-fishnet_install
Stockfish-fishnet_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/stockfish $(STAGING_INSTALL_PREFIX)/bin/
