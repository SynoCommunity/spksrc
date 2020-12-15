PKG_NAME = libffi
PKG_VERS = 3.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://github.com/libffi/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://sourceware.org/libffi/
COMMENT  = A Portable Foreign Function Interface Library
LICENSE  = libffi BSD-like

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libffi_pre_configure
CONFIGURE_ARGS = enable_multi_os_directory=no

include ../../mk/spksrc.cross-cc.mk

.PHONY: libffi_pre_configure
libffi_pre_configure:
	$(RUN) ./autogen.sh
