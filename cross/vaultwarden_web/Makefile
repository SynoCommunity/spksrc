PKG_NAME = vaultwarden_web
PKG_VERS = 2025.12.1
PKG_EXT = tar.gz
PKG_DIST_NAME = bw_web_v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dani-garcia/bw_web_builds/releases/download/v$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/dani-garcia/vaultwarden/wiki
COMMENT = Web Vault build for Vaultwarden. Bitwarden web vault, patched to work with vaultwarden.
LICENSE = GPLv3

INSTALL_TARGET = vaultwarden_web_install

include ../../mk/spksrc.install-resources.mk

.PHONY: vaultwarden_web_install
vaultwarden_web_install:
	@$(MSG) Extract bitwarden_web for vaultwarden into web-vault
	mv -f $(WORK_DIR)/web-vault $(STAGING_INSTALL_PREFIX)
