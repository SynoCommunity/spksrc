PKG_NAME = zlib
PKG_VERS = 1.3.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://zlib.net/fossils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://zlib.net/
COMMENT  = A Massively Spiffy Yet Delicately Unobtrusive Compression Library.
LICENSE  = zlib-license

ADDITIONAL_CFLAGS = -Os -fPIC

# create pkgconfig file in lib/pkgconfig (instead of share/pkgconfig)
CMAKE_ARGS += -DINSTALL_PKGCONFIG_DIR=$(INSTALL_PREFIX)/lib/pkgconfig
CMAKE_ARGS += -DZLIB_BUILD_EXAMPLES=OFF

include ../../mk/spksrc.cross-cmake.mk
