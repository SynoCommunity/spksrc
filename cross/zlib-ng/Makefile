PKG_NAME = zlib-ng
PKG_VERS = 2.0.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/zlib-ng/zlib-ng/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.archs.mk
ifneq ($(findstring $(ARCH),$(DSM_ARMv7_ARCHS)),$(ARCH))
CMAKE_ARGS += -DWITH_ACLE=no
endif

HOMEPAGE = https://github.com/zlib-ng/zlib-ng
COMMENT  = zlib replacement with optimizations for "next generation" systems.
LICENSE  = zlib-license

include ../../mk/spksrc.cross-cmake.mk
