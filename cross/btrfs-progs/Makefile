PKG_NAME = btrfs-progs
PKG_VERS = 5.10.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kdave/btrfs-progs/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/zlib
DEPENDS += cross/zstd
DEPENDS += cross/lzo
DEPENDS += cross/libmount
DEPENDS += cross/libuuid

HOMEPAGE = https://btrfs.readthedocs.io/
# compsize 1.5 needs the kernel compatibility definitions shipped by the
# libbtrfs headers through 5.10.1; newer btrfs-progs removed them.
COMMENT = Userspace utilities and libraries for the Btrfs filesystem.
LICENSE = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = btrfs-progs_pre_configure

CONFIGURE_ARGS = --disable-documentation
CONFIGURE_ARGS += --disable-programs
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-convert
CONFIGURE_ARGS += --disable-python
CONFIGURE_ARGS += --disable-libudev

include ../../mk/spksrc.cross-cc.mk

.PHONY: btrfs-progs_pre_configure
btrfs-progs_pre_configure:
	@$(RUN) ./autogen.sh
