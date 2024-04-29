PKG_NAME = gensio
PKG_VERS = 2.8.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/cminyard/gensio/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/cminyard/gensio
COMMENT  = A library to abstract stream I/O like serial port, TCP, telnet, UDP, SSL, IPMI SOL, etc.
LICENSE  = GPLv2

# qoriq is the only PPC arch that is supported
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/openssl3

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = gensio_pre_configure

CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --without-python
CONFIGURE_ARGS += --without-swig
CONFIGURE_ARGS += --disable-doc

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# archs/toolchains without compatible RS485 support (linux serial.h)
CONFIGURE_ARGS += ac_cv_have_decl_TIOCSRS485=no
endif

.PHONY: gensio_pre_configure
gensio_pre_configure:
	$(RUN) autoreconf -i 
