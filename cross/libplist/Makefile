PKG_NAME = libplist
PKG_VERS = 2.0.0
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = ec9ba8bff6a4469aa75f6d570ab5109c061c6a9e
PKG_DIST_SITE = https://github.com/libimobiledevice/$(PKG_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = https://github.com/libimobiledevice/libplist/
COMMENT  = A small portable C library to handle Apple Property List files in binary or XML.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libplist_pre_configure
INSTALL_TARGET = libplist_extra_install
CONFIGURE_ARGS = --without-cython

include ../../mk/spksrc.cross-cc.mk


ifeq ($(findstring $(ARCH), $(ARM_ARCHES)),$(ARCH))
libplist_pre_configure:
	$(RUN) ; ./autogen.sh --without-cython --host=arm-linux
else
libplist_pre_configure:
	$(RUN) ; ./autogen.sh --without-cython
endif

libplist_extra_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
