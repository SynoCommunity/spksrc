PKG_NAME = xapian-core
PKG_VERS = 1.4.31
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).orig.$(PKG_EXT)
PKG_DIST_SITE = http://deb.debian.org/debian/pool/main/x/xapian-core
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
