PKG_NAME = testdisk
PKG_VERS = 7.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.cgsecurity.org
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/ncursesw cross/libjpeg cross/zlib
DEPENDS += cross/e2fsprogs cross/ntfs-3g_ntfsprogs cross/libewf cross/progsreiserfs

HOMEPAGE = https://www.cgsecurity.org/wiki/TestDisk
COMMENT  = TestDisk is powerful free data recovery software.
LICENSE  = 

GNU_CONFIGURE = 1

ADDITIONAL_CFLAGS = -O -Wno-unused-parameter -Wno-attributes -Wno-cast-align -Wno-sign-compare -Wno-inline

include ../../mk/spksrc.cross-cc.mk
