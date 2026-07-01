### TEMPORARY download test (git method) - demo, to be archived.
PKG_NAME = demodl-git
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = master
PKG_DIST_SITE = https://github.com/octocat/Hello-World.git

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
