PKG_NAME = flac
PKG_VERS = 1.4.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.osuosl.org/pub/xiph/releases/$(PKG_NAME)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libogg

HOMEPAGE = https://xiph.org/flac/download.html
COMMENT  = Free Lossless Audio Codec.
LICENSE  = GPL

GNU_CONFIGURE = 1

# warning _FORTIFY_SOURCE requires compiling with optimization (-O)
ADDITIONAL_CPPFLAGS = -Os

# Required for linking microbench/util.c on cross toolchains
ADDITIONAL_LDFLAGS = -lrt

CONFIGURE_ARGS = --disable-thorough-tests --disable-doxygen-docs --disable-oggtest

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# avoid error: AltiVec and SPE instructions cannot coexist
CONFIGURE_ARGS += --disable-altivec
endif

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# force disable of -fstack-protector-strong
# where gcc does not support it - but g++ does and configure would enable it.
CONFIGURE_ARGS += enable_stack_smash_protection=no
endif
