### TEMPORARY download test (X.org family) - demo, to be archived.
PKG_NAME = demodl-xorg
PKG_DIST_NAME = util-macros-1.20.0.tar.xz
PKG_DIST_SITE = https://www.x.org/releases/individual/util

CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
PATCH_TARGET = nop
INSTALL_TARGET = demodl_install

include ../../mk/spksrc.common.mk

include ../../mk/spksrc.cross-install.mk

.PHONY: demodl_install
demodl_install:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/share/demodl
	@echo "$(PKG_NAME): download + install reached - OK" > $(STAGING_INSTALL_PREFIX)/share/demodl/$(PKG_NAME).ok
