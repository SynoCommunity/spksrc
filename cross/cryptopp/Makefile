PKG_NAME = cryptopp
PKG_VERS = 8.2.0
PKG_EXT = tar.gz
DIST_BASE_NAME=CRYPTOPP_$(subst .,_,$(PKG_VERS))
PKG_DIST_NAME = $(DIST_BASE_NAME).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/weidai11/$(PKG_NAME)/archive/
PKG_DIR = $(PKG_NAME)-$(DIST_BASE_NAME)

# PPC_ARCHES except qoirq
# ppc_power9.cpp: In function 'bool CryptoPP::CPU_ProbeDARN()':
# ppc_power9.cpp:104: error: 'NULL' was not declared in this scope
UNSUPPORTED_ARCHS = powerpc ppc824x ppc853x ppc854

HOMEPAGE = 
COMMENT  = 
LICENSE  =

CONFIGURE_TARGET = nop
COMPILE_TARGET = cryptopp_compile
INSTALL_TARGET = cryptopp_install

ADDITIONAL_CXXFLAGS = -DNDEBUG -g2 -O3 -fPIC -pipe

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(ARM5_ARCHES) $(ARM7_ARCHES)),$(ARCH))
# makefile for arm archs (except arm64)
MAKEFILE = GNUmakefile-cross
else
MAKEFILE = GNUmakefile
endif


.PHONY: cryptopp_compile
cryptopp_compile:
	@$(RUN) make -f $(MAKEFILE) HAS_SOLIB_VERSION=1 shared

.PHONY: cryptopp_install
cryptopp_install:
	@$(RUN) make -f $(MAKEFILE) HAS_SOLIB_VERSION=1 install-lib DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
