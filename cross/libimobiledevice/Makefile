PKG_NAME = libimobiledevice
PKG_VERS = 1.2.0
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 26373b334889f5ae2e2737ff447eb25b1700fa2f
PKG_DIST_SITE = https://github.com/libimobiledevice/$(PKG_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/libplist cross/libusbmuxd cross/openssl

HOMEPAGE = https://github.com/libimobiledevice/libimobiledevice/
COMMENT  = A library to communicate with services of Apple iOS devices using native protocols.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libimobiledevice_pre_configure
INSTALL_TARGET = libimobiledevice_extra_install
CONFIGURE_ARGS = --disable-largefile --without-cython --enable-debug-code

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(ARM_ARCHES)),$(ARCH))
libimobiledevice_pre_configure:
	$(RUN) ; ./autogen.sh --disable-largefile --without-cython --enable-debug-code --host=arm-linux
else
libimobiledevice_pre_configure:
	$(RUN) ; ./autogen.sh --disable-largefile --without-cython --enable-debug-code
endif

libimobiledevice_extra_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
