PKG_NAME = gensio
PKG_VERS = 1.5.6
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/cminyard/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/cminyard/gensio
COMMENT  = gensio - General Stream I/O
LICENSE  = GPLv2

# qoriq is the only PPC arch that is supported
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/openssl

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = gensio_pre_configure

CONFIGURE_ARGS  = --with-python=no --with-swig=no

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# archs/toolchains without compatible RS485 support (linux serial.h)
CONFIGURE_ARGS += ac_cv_have_decl_TIOCSRS485=no
endif

.PHONY: gensio_pre_configure
gensio_pre_configure:
	$(RUN) autoreconf -i 
