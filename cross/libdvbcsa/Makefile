PKG_NAME = libdvbcsa
PKG_VERS = unknown
PKG_EXT = tar.gz
# git hash from Jan 28th 2018
PKG_GIT_HASH = 2a1e61e569a621c55c2426f235f42c2398b7f18f
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/glenvt18/libdvbcsa/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

DEPENDS = 

GNU_CONFIGURE = 1
HOMEPAGE = https://www.videolan.org/developers/libdvbcsa.html
COMMENT  = libdvbcsa is a free implementation of the DVB Common Scrambling Algorithm - DVB/CSA - with encryption and decryption capabilities.
LICENSE  = GPL

CONFIGURE_ARGS  = --enable-shared
CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)

PRE_CONFIGURE_TARGET = libdvbcsa_pre_configure
PATCHES_LEVEL = 1

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-neon
endif

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-sse2
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-avx2
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: libdvbcsa_pre_configure
libdvbcsa_pre_configure:
	$(RUN) ./bootstrap
