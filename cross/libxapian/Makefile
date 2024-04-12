PKG_NAME = xapian-core
PKG_VERS = 1.4.25
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://oligarchy.co.uk/xapian/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libuuid cross/zlib

# toolchains lacking C++11 compiler:
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://xapian.org/
COMMENT  = Xapian is an Open Source Search Engine Library.
LICENSE  = GPLv2+

GNU_CONFIGURE = 1

ADDITIONAL_CPPFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
