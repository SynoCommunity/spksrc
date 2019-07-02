PKG_NAME = ifuse
PKG_VERS = 1.1.3
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = df048a1d07628a6a02ed77a8dc0f64930b78acee
PKG_DIST_SITE = https://github.com/libimobiledevice/$(PKG_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/libplist cross/libimobiledevice cross/fuse

HOMEPAGE = https://github.com/libimobiledevice/ifuse/
COMMENT  = A fuse filesystem implementation to access the contents of iOS devices.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = ifuse_pre_configure
INSTALL_TARGET = ifuse_extra_install

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(ARM_ARCHES)),$(ARCH))
ifuse_pre_configure:
	$(RUN) ; ./autogen.sh --host=arm-linux
else
ifuse_pre_configure:
	$(RUN) ; ./autogen.sh
endif

ifuse_extra_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
