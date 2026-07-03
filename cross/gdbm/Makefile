PKG_NAME = gdbm
PKG_VERS = 1.23
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/gdbm
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/gdbm/
COMMENT  = GNU dbm is a library of functions implementing a hashed database on a disk file.
LICENSE  = GPLv2/LGPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --enable-libgdbm-compat

# fix unknown type blksize_t for older compilers (https://github.com/Homebrew/linuxbrew-core/pull/6242)
ADDITIONAL_CFLAGS = -D_GNU_SOURCE

include ../../mk/spksrc.cross-cc.mk
