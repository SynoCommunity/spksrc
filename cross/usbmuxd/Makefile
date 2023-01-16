PKG_NAME = usbmuxd
PKG_VERS = 1.1.0
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
# with commits on Oct 4, 2019 
PKG_GIT_HASH = c41226df521de464a89f3d027f3e67d13d10d96f
PKG_DIST_SITE = https://github.com/libimobiledevice/$(PKG_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/libplist cross/libimobiledevice cross/libusb

HOMEPAGE = https://github.com/libimobiledevice/usbmuxd/
COMMENT  = A socket daemon to multiplex connections from and to iOS devices.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = usbmuxd_pre_configure
CONFIGURE_ARGS = ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
USBMUXD_AUTOGEN_ARGS = --without-cpython

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
USBMUXD_AUTOGEN_ARGS += --host=arm-linux
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
USBMUXD_AUTOGEN_ARGS += --host=ppc-linux
endif

.PHONY: usbmuxd_pre_configure
usbmuxd_pre_configure:
	$(RUN) NOCONFIGURE=1 ./autogen.sh $(USBMUXD_AUTOGEN_ARGS)
