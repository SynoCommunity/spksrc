PKG_NAME = Stockfish
PKG_SHORT_NAME = sf
PKG_VERS = 11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_SHORT_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/official-stockfish/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_SHORT_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_SHORT_NAME)_$(PKG_VERS)/src

HOMEPAGE = https://stockfishchess.org/
COMMENT  = Stockfish is a strong open source chess engine
LICENSE  = GPLv2/GPLv3

CONFIGURE_TARGET = nop
INSTALL_TARGET = stockfish_install

include ../../mk/spksrc.archs.mk

# Toolchains lacking c++11 compiler ar not supported
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
ifeq ($(BUILD_ARCH),)
$(error "ARCH $(ARCH) not expected.")
endif

COMPILE_MAKE_OPTIONS = build ARCH=$(BUILD_ARCH)
ifeq (g++,$(CXX))
# workaround for: CXX not fully qualified when building in cross folder
COMPILE_MAKE_OPTIONS += COMPCXX=$(TC_PATH)$(TC_PREFIX)$(CXX)
else
COMPILE_MAKE_OPTIONS += COMPCXX=$(CXX)
endif


.PHONY: stockfish_install
stockfish_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/stockfish $(STAGING_INSTALL_PREFIX)/bin/
