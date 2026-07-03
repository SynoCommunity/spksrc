PKG_NAME = libffi
PKG_VERS = 3.4.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libffi/libffi/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://sourceware.org/libffi/
COMMENT  = A Portable Foreign Function Interface Library.
LICENSE  = libffi BSD-like

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += enable_multi_os_directory=no
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
