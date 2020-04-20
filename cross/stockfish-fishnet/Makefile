PKG_NAME = fishnet
PKG_VERS = 180120
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/niklasf/Stockfish/archive/
PKG_DIR = Stockfish-$(PKG_NAME)-$(PKG_VERS)
PKG_WORK_DIR = $(WORK_DIR)/$(PKG_DIR)/src/

HOMEPAGE = https://github.com/niklasf/Stockfish/tree/fishnet
COMMENT  = Stockfish engine for lichess which supports variants and can be used with fishnet (http://lichess.org/get-fishnet)
LICENSE  = GPLv2/GPLv3

CONFIGURE_TARGET = nope
COMPILE_TARGET = stockfish_fishnet_compile
INSTALL_TARGET = stockfish_fishnet_install

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

.PHONY: stockfish_fishnet_compile
stockfish_fishnet_compile:
	cd $(PKG_WORK_DIR) && $(ENV) $(MAKE) build ARCH=$(BUILD_ARCH) COMPCXX=$(CXX)

.PHONY: stockfish_fishnet_install
stockfish_fishnet_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install $(PKG_WORK_DIR)stockfish $(STAGING_INSTALL_PREFIX)/bin/stockfish-fishnet
