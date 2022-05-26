PKG_NAME = giflib
PKG_VERS = 5.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/giflib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://sourceforge.net/projects/giflib
COMMENT  = A library for processing GIFs.
LICENSE  = MIT

CONFIGURE_TARGET = nop
INSTALL_TARGET = giflib_install

include ../../mk/spksrc.cross-cc.mk

ifeq ($(call version_ge, $(TC_GCC), 4.6),1)
# add CFLAGS not supported by older compilers
COMPILE_MAKE_OPTIONS = ADDITIONAL_CFLAGS=-Wno-format-truncation
endif

.PHONY: giflib_install
giflib_install:
	@$(RUN) $(MAKE) PREFIX=$(INSTALL_DIR)$(INSTALL_PREFIX) install
