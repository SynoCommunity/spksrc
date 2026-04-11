PKG_NAME = newt
PKG_VERS = 0.52.24
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://releases.pagure.org/newt
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/slang
DEPENDS += cross/popt

HOMEPAGE = https://pagure.io/newt
COMMENT  = Newt is a programming library for color text mode, widget based user interfaces.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

# let it find python*-configure
ENV += PATH=$$PATH:$(PYTHON_STAGING_INSTALL_PREFIX)/bin

PYTHONVERS = $(notdir $(wildcard $(or $(PYTHON_STAGING_INSTALL_PREFIX),$(STAGING_INSTALL_PREFIX))/include/python3*))
ADDITIONAL_CFLAGS += -I$(or $(PYTHON_STAGING_INSTALL_PREFIX),$(STAGING_INSTALL_PREFIX))/include/$(PYTHONVERS) -O
CONFIGURE_ARGS  = --with-python=$(PYTHONVERS)
CONFIGURE_ARGS += --without-tcl

PRE_CONFIGURE_TARGET = newt_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: newt_pre_configure
newt_pre_configure:
	@$(RUN) ; ./autogen.sh
