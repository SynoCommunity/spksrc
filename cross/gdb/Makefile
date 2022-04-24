PKG_NAME = gdb
PKG_VERS = 11.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/gdb
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libexpat cross/gmp cross/ncursesw cross/mpfr

HOMEPAGE = https://www.gnu.org/software/gdb/
COMMENT  = The GNU Project Debugger
LICENSE  = GPLv2/LGPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --enable-host-shared
CONFIGURE_ARGS += --with-system-zlib

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

include ../../mk/spksrc.cross-cc.mk
