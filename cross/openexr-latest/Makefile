PKG_NAME = openexr
PKG_VERS = 2.5.10
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/AcademySoftwareFoundation/openexr/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# OpenEXR v3.0.x will require DSM >= 7.0
# OpenEXR v3.3.x will require DSM >= 7.2

DEPENDS = cross/zlib

# Toolchains lacking a c++11 compiler are not supported. One floor replaces both the arch
# list and the x86-5.2 exception: that arch runs gcc 4.7.3, which fails the same C++11
# check as the ARMv5 and old PowerPC ones.
MIN_GCC_VERSION = 4.8

HOMEPAGE = https://www.openexr.com/
COMMENT  = OpenEXR provides the specification and reference implementation of the EXR file format, the professional-grade image storage format of the motion picture industry.
LICENSE  = 3-Clause BSD

CONFIGURE_ARGS += -DBUILD_TESTING=OFF
CONFIGURE_ARGS += -DPYILMBASE_ENABLE=OFF
CONFIGURE_ARGS += -DOPENEXR_BUILD_UTILS=OFF
CONFIGURE_ARGS += -DINSTALL_OPENEXR_EXAMPLES=OFF
CONFIGURE_ARGS += -DINSTALL_OPENEXR_DOCS=OFF

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
# default is c++14, supported by DSM >= 7 only
CONFIGURE_ARGS += -DCMAKE_CXX_STANDARD=11
endif

include ../../mk/spksrc.cross-cmake.mk
