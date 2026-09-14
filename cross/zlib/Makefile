PKG_NAME = zlib
PKG_VERS = 1.3.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
# Primary: GitHub release CDN (most reliable, byte-identical to upstream).
# Fallback: canonical fossils archive (permanent for pinned versions).
PKG_DIST_SITE = https://github.com/madler/zlib/releases/download/v$(PKG_VERS)
PKG_DIST_MIRRORS = https://zlib.net/fossils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://zlib.net/
COMMENT  = A Massively Spiffy Yet Delicately Unobtrusive Compression Library.
LICENSE  = zlib-license

ADDITIONAL_CFLAGS = -Os -fPIC

# create pkgconfig file in lib/pkgconfig (instead of share/pkgconfig)
CONFIGURE_ARGS += -DINSTALL_PKGCONFIG_DIR=$(INSTALL_PREFIX)/lib/pkgconfig
CONFIGURE_ARGS += -DZLIB_BUILD_EXAMPLES=OFF

include ../../mk/spksrc.cross-cmake.mk
