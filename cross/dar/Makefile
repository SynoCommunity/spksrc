PKG_NAME = dar
PKG_VERS = 2.5.22
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/dar/files/dar/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

OPTIONAL_DEPENDS = cross/libthreadar

# archs without C++11 support are not supported:
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

DEPENDS  = cross/attr
DEPENDS += cross/libgcrypt cross/gpgme
DEPENDS += cross/zlib cross/bzip2 cross/lzo cross/xz
DEPENDS += cross/e2fsprogs

HOMEPAGE = http://dar.linux.free.fr/
COMMENT = Disk ARchive - dar is a shell command that backs up from a single file to a whole filesystems, taking care of hard links, Extended Attributes, sparse files, etc.
LICENSE = GPLv3

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
# use invariant integers, build for 64bit mode fails on src/libdar/macro_tools.cpp
PLIST_TRANSFORM = sed -e 's|libdar64|libdar|'
else
CONFIGURE_ARGS = --enable-mode=64
DEPENDS += cross/libthreadar
endif

GNU_CONFIGURE = 1

CONFIGURE_ARGS += --enable-special-alloc
CONFIGURE_ARGS += --disable-dar-static
CONFIGURE_ARGS += --disable-upx
CONFIGURE_ARGS += --with-gpgme-prefix=$(STAGING_INSTALL_PREFIX)

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
