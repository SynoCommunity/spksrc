PKG_NAME = xapian-core
PKG_VERS = 2.1.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://oligarchy.co.uk/xapian/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libuuid cross/zlib

# C++ Compiler must support -std=c++17
MIN_GCC_VERSION = 7.5

HOMEPAGE = https://xapian.org/
COMMENT = Xapian is an Open Source Search Engine Library.
LICENSE = GPLv2+

GNU_CONFIGURE = 1

ADDITIONAL_CPPFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
