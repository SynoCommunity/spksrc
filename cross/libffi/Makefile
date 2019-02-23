PKG_NAME = libffi
PKG_VERS = 3.2.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceware.org/pub/$(PKG_NAME)

DEPENDS =

HOMEPAGE = http://sourceware.org/libffi/
COMMENT  = A Portable Foreign Function Interface Library
LICENSE  = libffi BSD-like

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libffi_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: libffi_pre_configure
libffi_pre_configure:
	$(RUN) autoconf
	$(RUN) aclocal
	$(RUN) automake
