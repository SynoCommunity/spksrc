### TEMPORARY download test (GNU family) - demo, to be archived.
PKG_NAME = demodl-gnu
PKG_DIST_NAME = hello-2.12.tar.gz
PKG_DIST_SITE = https://ftp.gnu.org/gnu/hello

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
