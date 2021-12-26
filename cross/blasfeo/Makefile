PKG_NAME = blasfeo
PKG_VERS = 0.1.2
PKG_EXT = tar.gz
# git hash from December 24th 2021
PKG_GIT_HASH = 7775cf91e2228a568a2e885e0ea1cc4a9aeb6955
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/giaf/blasfeo/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

DEPENDS = 

HOMEPAGE = https://github.com/giaf/blasfeo
COMMENT  = BLASFEO provides a set of basic linear algebra routines, performance-optimized for matrices that fit in cache (i.e. generally up to a couple hundred size in each dimension), as typically encountered in embedded optimization applications.
LICENSE  = BSD-2

GNU_CONFIGURE = 1

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CMAKE_ARGS += -DCMAKE_C_FLAGS=-std=gnu99 -lrt
endif

include ../../mk/spksrc.cross-cmake.mk
