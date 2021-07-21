PKG_NAME = flac
PKG_VERS = 1.3.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.osuosl.org/pub/xiph/releases/$(PKG_NAME)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libogg

HOMEPAGE = https://xiph.org/flac/download.html
COMMENT  = Free Lossless Audio Codec
LICENSE  = GPL

GNU_CONFIGURE = 1

# Required for linking microbench/util.c on cross toolchains
ADDITIONAL_LDFLAGS = -lrt

CONFIGURE_ARGS = --disable-thorough-tests --disable-doxygen-docs --disable-oggtest

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# avoid error: AltiVec and SPE instructions cannot coexist
CONFIGURE_ARGS += --disable-altivec
endif
