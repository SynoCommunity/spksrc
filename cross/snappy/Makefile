PKG_NAME = snappy
PKG_VERS = 1.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/google/snappy/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

# c++11 compiler required
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://google.github.io/snappy/
COMMENT  = Snappy is a compression/decompression library. It does not aim for maximum compression, or compatibility with any other compression library; instead, it aims for very high speeds and reasonable compression.
LICENSE  = Copyright 2011, Google Inc.

CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON
CMAKE_ARGS += -DSNAPPY_BUILD_TESTS=OFF
CMAKE_ARGS += -DSNAPPY_BUILD_BENCHMARKS=OFF

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),comcerto2k),$(ARCH))
CMAKE_ARGS += -DSNAPPY_HAVE_NEON=OFF
endif

include ../../mk/spksrc.cross-cmake.mk
