PKG_NAME = sjpeg
PKG_VERS = 1
PKG_EXT = tar.gz
# git hash from 2025.06.05
PKG_GIT_HASH = 46da5aec5fce05faabf1facf0066e36e6b1c4dff
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/webmproject/sjpeg/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

# gcc takes -std=c++11 from 4.7, and 4.6 rejects the in-class initializer:
#   src/sjpeg.h:258: error: ISO C++ forbids in-class initialization of
#   non-const static member 'xmp_split_point'
MIN_GCC_VERSION = 4.7

HOMEPAGE = https://github.com/webmproject/sjpeg/
COMMENT  = SimpleJPEG: simple jpeg encoder.
LICENSE  = Apache 2.0

include ../../mk/spksrc.cross-cmake.mk
