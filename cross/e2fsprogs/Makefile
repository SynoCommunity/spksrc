PKG_NAME = e2fsprogs
PKG_VERS = 1.46.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libuuid

HOMEPAGE = http://e2fsprogs.sourceforge.net/
COMMENT  = Ext2/3/4 filesystem userspace utilities.
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-elf-shlibs
# use cross/libuuid instead
CONFIGURE_ARGS += --disable-libuuid

include ../../mk/spksrc.archs.mk

# This is more a toolchain than an arch limitation
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-defrag
PLIST_TRANSFORM = sed -e '/bin:sbin\/e4defrag/d'
endif

# older gcc does not support 'link time optimization'
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-lto
endif

include ../../mk/spksrc.cross-cc.mk
