PKG_NAME = libplist
PKG_VERS = 2.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libimobiledevice/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/libimobiledevice/libplist/
COMMENT  = A small portable C library to handle Apple Property List files in binary or XML.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libplist_pre_configure
CONFIGURE_ARGS = --without-cython
LIBPLIST_AUTOGEN_ARGS = $(CONFIGURE_ARGS)

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
LIBPLIST_AUTOGEN_ARGS += --host=arm-linux
endif
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
LIBPLIST_AUTOGEN_ARGS += --host=ppc-linux
endif

.PHONY: libplist_pre_configure
libplist_pre_configure:
	$(RUN) ; NOCONFIGURE=1 ./autogen.sh $(LIBPLIST_AUTOGEN_ARGS)
