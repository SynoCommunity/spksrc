PKG_NAME = gpart
PKG_VERS = 0.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/baruch/gpart/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# glibc 2.8 has no htole16/le16toh in <endian.h> (added in 2.9):
#   gpart.c: undefined reference to `htole16'
MIN_GLIBC_VERSION = 2.9

HOMEPAGE = https://github.com/baruch/gpart
COMMENT  = Gpart is a small tool which tries to guess what partitions are on a PC type, MBR-partitioned hard disk in case the primary partition table was damaged.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = gpart_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: gpart_pre_configure
gpart_pre_configure:
	@$(RUN) autoreconf -i
