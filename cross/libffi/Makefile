PKG_NAME = libffi
PKG_VERS = 3.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libffi/$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://sourceware.org/libffi/
COMMENT  = A Portable Foreign Function Interface Library
LICENSE  = libffi BSD-like

GNU_CONFIGURE = 1
CONFIGURE_ARGS = enable_multi_os_directory=no

include ../../mk/spksrc.cross-cc.mk
