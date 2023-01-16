PKG_NAME = libusbmuxd
PKG_VERS = 2.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libimobiledevice/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libplist

HOMEPAGE = https://github.com/libimobiledevice/libusbmuxd/
COMMENT  = A client library to multiplex connections from and to iOS devices by connecting to a socket provided by a usbmuxd daemon.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libusbmuxd_pre_configure
CONFIGURE_ARGS = ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
LIBUSBMUXD_AUTOGEN_ARGS =

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
	LIBUSBMUXD_AUTOGEN_ARGS += --host=arm-linux
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
	LIBUSBMUXD_AUTOGEN_ARGS += --host=ppc-linux
endif

.PHONY: libusbmuxd_pre_configure
libusbmuxd_pre_configure:
	$(RUN) NOCONFIGURE=1 ./autogen.sh $(LIBUSBMUXD_AUTOGEN_ARGS)
