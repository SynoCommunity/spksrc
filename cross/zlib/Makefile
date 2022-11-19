PKG_NAME = zlib
PKG_VERS = 1.2.13
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://zlib.net/fossils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://zlib.net/
COMMENT  = A Massively Spiffy Yet Delicately Unobtrusive Compression Library.
LICENSE  = zlib-license

ADDITIONAL_CFLAGS = -Os -fPIC

# fix pkgconfig file
# build with cross-cc creates wrong pkgconfig file (prefix without missing package name)
# build with cross-cmake creates correct pkgconfig file, but default folder is share not lib
CMAKE_ARGS += -DINSTALL_PKGCONFIG_DIR=$(INSTALL_PREFIX)/lib/pkgconfig

include ../../mk/spksrc.cross-cmake.mk
