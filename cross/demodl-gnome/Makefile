### TEMPORARY download test (GNOME family) - demo, to be archived.
PKG_NAME = demodl-gnome
PKG_DIST_NAME = glib-2.66.8.tar.xz
PKG_DIST_SITE = https://download.gnome.org/sources/glib/2.66

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
