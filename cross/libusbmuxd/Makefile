PKG_NAME = libusbmuxd
PKG_VERS = 1.0.10
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 149da9b53a7d16f6056337bfa0ed55f44466007a
PKG_DIST_SITE = https://github.com/libimobiledevice/$(PKG_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/libplist

HOMEPAGE = https://github.com/libimobiledevice/libusbmuxd/
COMMENT  = A client library to multiplex connections from and to iOS devices by connecting to a socket provided by a usbmuxd daemon.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libusbmuxd_pre_configure
INSTALL_TARGET = libusbmuxd_extra_install
CONFIGURE_ARGS = ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(ARM_ARCHES)),$(ARCH))
libusbmuxd_pre_configure:
	$(RUN) ; ./autogen.sh --host=arm-linux
else
libusbmuxd_pre_configure:
	$(RUN) ; ./autogen.sh
endif

libusbmuxd_extra_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
