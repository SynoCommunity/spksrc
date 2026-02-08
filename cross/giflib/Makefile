PKG_NAME = giflib
PKG_VERS = 5.2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/giflib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://sourceforge.net/projects/giflib
COMMENT  = A library for processing GIFs.
LICENSE  = MIT

CONFIGURE_TARGET = nop
COMPILE_MAKE_OPTIONS = shared-lib
INSTALL_MAKE_OPTIONS = PREFIX=$(INSTALL_DIR)$(INSTALL_PREFIX) install-shared-lib

include ../../mk/spksrc.cross-cc.mk

ifeq ($(call version_ge, $(TC_GCC), 4.6),1)
# add CFLAGS not supported by older compilers
COMPILE_MAKE_OPTIONS = ADDITIONAL_CFLAGS=-Wno-format-truncation
endif
