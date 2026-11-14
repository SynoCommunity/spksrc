PKG_NAME = testdisk
PKG_VERS = 7.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.cgsecurity.org
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/ncursesw cross/libjpeg cross/zlib
DEPENDS += cross/e2fsprogs cross/ntfs-3g_ntfsprogs cross/libewf cross/progsreiserfs

HOMEPAGE = https://www.cgsecurity.org/wiki/TestDisk
COMMENT  = TestDisk is powerful free data recovery software.
LICENSE  = GPLv2+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-qt
# The configure probes test these without linking libewf; both are present in our libewf.
CONFIGURE_ARGS += ac_cv_func_libewf_handle_read_buffer_at_offset=yes
CONFIGURE_ARGS += ac_cv_func_libewf_handle_write_buffer_at_offset=yes

ADDITIONAL_CFLAGS = -O -Wno-unused-parameter -Wno-attributes -Wno-cast-align -Wno-sign-compare -Wno-inline

include ../../mk/spksrc.common.mk

# GCC < 5 rejects compound literals in static initializers; gnu89 accepts them as an extension.
ifeq ($(call version_lt,$(TC_GCC),5.0),1)
ADDITIONAL_CFLAGS += -std=gnu89
endif

include ../../mk/spksrc.cross-cc.mk
