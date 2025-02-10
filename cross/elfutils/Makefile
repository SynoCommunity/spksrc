PKG_NAME = elfutils
PKG_VERS = 0.191
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceware.org/elfutils/ftp/0.191
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/zstd

HOMEPAGE = https://sourceware.org/elfutils/
COMMENT  = elfutils is a collection of utilities and libraries to read, create and modify ELF binary files, find and handle DWARF debug data, symbols, thread state and stacktraces for processes and core files on GNU/Linux.
LICENSE  = GPL

REQUIRED_MIN_DSM = 7.0

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-libdebuginfod
CONFIGURE_ARGS += --disable-debuginfod

include ../../mk/spksrc.cross-cc.mk
