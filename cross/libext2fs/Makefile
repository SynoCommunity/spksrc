PKG_NAME = libext2fs
# use the same source as for cross/e2fsprogs, but include the shared libraries only.
PKG_VERS = 1.46.5
PKG_EXT = tar.gz
PKG_DIST_NAME = e2fsprogs-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v$(PKG_VERS)
PKG_DIR = e2fsprogs-$(PKG_VERS)

DEPENDS = cross/libuuid

HOMEPAGE = http://e2fsprogs.sourceforge.net/
COMMENT  = libext2fs from ext2/3/4 filesystem userspace utilities.
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-elf-shlibs
# use cross/libuuid instead
CONFIGURE_ARGS += --disable-libuuid

# build and install libs only
COMPILE_MAKE_OPTIONS = libs
INSTALL_MAKE_OPTIONS = install-libs DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
