PKG_NAME = libimobiledevice
PKG_VERS = 1.2.0
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
# with commits on Jun 13, 2019
PKG_GIT_HASH = 6edc36fccb52a963c9ebfbb44ba7b91570e0fd06
PKG_DIST_SITE = https://github.com/libimobiledevice/$(PKG_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/libplist cross/libusbmuxd cross/openssl

HOMEPAGE = https://github.com/libimobiledevice/libimobiledevice/
COMMENT  = A library to communicate with services of Apple iOS devices using native protocols.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libimobiledevice_pre_configure
CONFIGURE_ARGS = --disable-largefile --without-cython
LIBIMOBILEDEVICE_AUTOGEN_ARGS = $(CONFIGURE_ARGS)

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
	LIBIMOBILEDEVICE_AUTOGEN_ARGS += --host=arm-linux
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
	LIBIMOBILEDEVICE_AUTOGEN_ARGS += --host=ppc-linux
endif

.PHONY: libimobiledevice_pre_configure
libimobiledevice_pre_configure:
	$(RUN) NOCONFIGURE=1 ./autogen.sh $(LIBIMOBILEDEVICE_AUTOGEN_ARGS)
