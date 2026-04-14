PKG_NAME = cryptopp
PKG_VERS = 8.9.0
PKG_EXT = tar.gz
DIST_BASE_NAME = CRYPTOPP_$(subst .,_,$(PKG_VERS))
PKG_DIST_NAME = $(DIST_BASE_NAME).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/weidai11/cryptopp/archive
PKG_DIR = $(PKG_NAME)-$(DIST_BASE_NAME)

DEPENDS =

HOMEPAGE = https://cryptopp.com/
COMMENT  = Crypto++ Library is a free C++ class library of cryptographic schemes.
LICENSE  = Boost Software License 1.0

CONFIGURE_TARGET = nop

ADDITIONAL_CXXFLAGS = -DNDEBUG -g2 -fPIC -pipe

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
# aarch64 fails to generate keys with optimized code
ADDITIONAL_CXXFLAGS += -O0
else
ADDITIONAL_CXXFLAGS += -O
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
# avoid errors like: unknown register name '%xmm5' in 'asm'
ADDITIONAL_CXXFLAGS += -DCRYPTOPP_DISABLE_SSE2
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
ADDITIONAL_CXXFLAGS += -DCRYPTOPP_DISABLE_ASM
endif

MAKE_OPTIONS = -f GNUmakefile HAS_SOLIB_VERSION=1

COMPILE_MAKE_OPTIONS = $(MAKE_OPTIONS) shared
INSTALL_MAKE_OPTIONS = $(MAKE_OPTIONS) install-lib DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
