PKG_NAME = e2fsprogs
PKG_VERS = 1.45.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://e2fsprogs.sourceforge.net/
COMMENT  = Ext2/3/4 filesystem userspace utilities
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-elf-shlibs

include ../../mk/spksrc.archs.mk

# This is more a toolchain than an arch limitation
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-defrag
PLIST_TRANSFORM = sed -e '/bin:sbin\/e4defrag/d'
endif

include ../../mk/spksrc.cross-cc.mk
