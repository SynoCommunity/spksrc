PKG_NAME = openexr
PKG_VERS = 2.5.8
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/AcademySoftwareFoundation/openexr/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

# Toolchains lacking c++11 compiler ar not supported  
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.openexr.com/
COMMENT  = OpenEXR provides the specification and reference implementation of the EXR file format, the professional-grade image storage format of the motion picture industry.
LICENSE  = 3-Clause BSD

CMAKE_USE_NINJA = 1  
CMAKE_ARGS += -DBUILD_TESTING=OFF
CMAKE_ARGS += -DOPENEXR_BUILD_UTILS=OFF

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
# default is c++14, supported by DSM >= 7 only
CMAKE_ARGS += -DCMAKE_CXX_STANDARD=11
endif

include ../../mk/spksrc.cross-cmake.mk
