PKG_NAME = ifuse
PKG_VERS = 1.1.3
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
# commited on Oct 8, 2018
PKG_GIT_HASH = e75d32c34d0e8b80320f0a007d5ecbb3f55ef7f0
PKG_DIST_SITE = https://github.com/libimobiledevice/$(PKG_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/libplist cross/libimobiledevice cross/fuse

HOMEPAGE = https://github.com/libimobiledevice/ifuse/
COMMENT  = A fuse filesystem implementation to access the contents of iOS devices.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = ifuse_pre_configure
INSTALL_TARGET = ifuse_install
IFUSE_AUTOGEN_ARGS =

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
IFUSE_AUTOGEN_ARGS += --host=arm-linux
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
IFUSE_AUTOGEN_ARGS += --host=ppc-linux
endif

.PHONY ifuse_pre_configure:
ifuse_pre_configure:
	$(RUN) ./autogen.sh $(IFUSE_AUTOGEN_ARGS)

.PHONY ifuse_install:
ifuse_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
