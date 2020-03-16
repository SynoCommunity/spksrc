PKG_NAME = libplist
PKG_VERS = 2.0.0
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
# with Commits on Sep 3, 2019
PKG_GIT_HASH = 6a53de92e2b5029ee293c79d481ff5fd9528f8c3
PKG_DIST_SITE = https://github.com/libimobiledevice/$(PKG_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = https://github.com/libimobiledevice/libplist/
COMMENT  = A small portable C library to handle Apple Property List files in binary or XML.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libplist_pre_configure
INSTALL_TARGET = libplist_install
CONFIGURE_ARGS = --without-cython
LIBPLIST_AUTOGEN_ARGS = $(CONFIGURE_ARGS)

include ../../mk/spksrc.cross-cc.mk


ifeq ($(findstring $(ARCH), $(ARM_ARCHES)),$(ARCH))
LIBPLIST_AUTOGEN_ARGS += --host=arm-linux
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
LIBPLIST_AUTOGEN_ARGS += --host=ppc-linux
endif


.PHONY: libplist_pre_configure
libplist_pre_configure:
	$(RUN) ; ./autogen.sh $(LIBPLIST_AUTOGEN_ARGS)

.PHONY: libplist_install
libplist_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
