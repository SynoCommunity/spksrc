PKG_NAME = flac
PKG_VERS = 1.5.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.osuosl.org/pub/xiph/releases/$(PKG_NAME)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libogg

HOMEPAGE = https://xiph.org/flac/download.html
COMMENT  = Free Lossless Audio Codec.
LICENSE  = GPL

# warning _FORTIFY_SOURCE requires compiling with optimization (-O)
ADDITIONAL_CPPFLAGS = -Os

# Required for linking microbench/util.c on cross toolchains
ADDITIONAL_LDFLAGS = -lrt

CMAKE_ARGS  = -DBUILD_TESTING=OFF
CMAKE_ARGS += -DBUILD_DOCS=OFF

include ../../mk/spksrc.common.mk

# force disable of -fstack-protector-strong
# where gcc does not support it - but g++ does and configure would enable it.
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
CMAKE_ARGS += -DWITH_STACK_PROTECTOR=OFF
endif

include ../../mk/spksrc.cross-cmake.mk
