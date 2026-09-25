PKG_NAME = openexr
PKG_VERS = 3.5.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/AcademySoftwareFoundation/openexr/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# OpenEXR 3.5 needs std::filesystem without -lstdc++fs (GCC 9+):
# GCC 7.5 lacks the header, GCC 8.5 fails the tools link. Verified.
MIN_GCC_VERSION = 9

DEPENDS = cross/zlib cross/imath

HOMEPAGE = https://www.openexr.com/
COMMENT  = OpenEXR provides the specification and reference implementation of the EXR file format, the professional-grade image storage format of the motion picture industry.
LICENSE  = 3-Clause BSD

CONFIGURE_ARGS += -DBUILD_TESTING=OFF
CONFIGURE_ARGS += -DPYILMBASE_ENABLE=OFF
CONFIGURE_ARGS += -DOPENEXR_BUILD_UTILS=OFF
CONFIGURE_ARGS += -DINSTALL_OPENEXR_EXAMPLES=OFF
CONFIGURE_ARGS += -DINSTALL_OPENEXR_DOCS=OFF

include ../../mk/spksrc.cross-cmake.mk
