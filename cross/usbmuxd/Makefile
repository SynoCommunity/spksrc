PKG_NAME = usbmuxd
PKG_VERS = 1.1.0
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 08d9ec01cf59c7bb3febe3c4600e9efeb81901e3
PKG_DIST_SITE = https://github.com/libimobiledevice/$(PKG_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/libplist cross/libimobiledevice cross/libusb

HOMEPAGE = https://github.com/libimobiledevice/usbmuxd/
COMMENT  = A socket daemon to multiplex connections from and to iOS devices.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = usbmuxd_pre_configure
INSTALL_TARGET = usbmuxd_extra_install
CONFIGURE_ARGS = ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(ARM_ARCHES)),$(ARCH))
usbmuxd_pre_configure:
	$(RUN) ; ./autogen.sh --host=arm-linux
else
usbmuxd_pre_configure:
	$(RUN) ; ./autogen.sh
endif

usbmuxd_extra_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
