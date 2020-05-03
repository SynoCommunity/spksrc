PKG_NAME = stockfish
PKG_DIST_FILE=sf
PKG_VERS = 11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_DIST_FILE)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/official-stockfish/Stockfish/archive/
PKG_DIR = Stockfish-$(PKG_DIST_FILE)_$(PKG_VERS)
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_DIR)/src/

HOMEPAGE = https://stockfishchess.org/ 
COMMENT  = Stockfish is a strong open source chess engine 
LICENSE  = GPLv2/GPLv3

CONFIGURE_TARGET = nope
COMPILE_TARGET = stockfish_compile
INSTALL_TARGET = stockfish_install

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
	BUILD_ARCH=armv7
endif

ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
	BUILD_ARCH=x86-32
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
	BUILD_ARCH=x86-64
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
	BUILD_ARCH=ppc-32
endif

ifeq ($(BUILD_ARCH),)
	  $(error Unsupported ARCH $(ARCH))
endif

.PHONY: stockfish_compile
stockfish_compile:
	cd $(PKG_WORK_DIR) && $(ENV) $(MAKE) build ARCH=$(BUILD_ARCH) COMPCXX=$(CXX)

.PHONY: stockfish_install
stockfish_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install $(PKG_WORK_DIR)stockfish $(STAGING_INSTALL_PREFIX)/bin/
