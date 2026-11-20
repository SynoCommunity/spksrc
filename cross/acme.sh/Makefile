PKG_NAME = acme.sh
PKG_VERS = 3.1.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/acmesh-official/acme.sh/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/acmesh-official/acme.sh
COMMENT  = A pure Unix shell script implementing ACME client protocol.
LICENSE  = GPL-3.0

INSTALL_TARGET = acme_sh_install

include ../../mk/spksrc.cross-install.mk

# Installed as a program folder (acme.sh plus its DNS, deploy and notify
# plugins) for packages that run acme.sh with their own --home.
.PHONY: acme_sh_install
acme_sh_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/acme.sh
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/acme.sh $(STAGING_INSTALL_PREFIX)/acme.sh/
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/LICENSE.md $(STAGING_INSTALL_PREFIX)/acme.sh/
	cp -R $(WORK_DIR)/$(PKG_DIR)/dnsapi $(WORK_DIR)/$(PKG_DIR)/deploy $(WORK_DIR)/$(PKG_DIR)/notify $(STAGING_INSTALL_PREFIX)/acme.sh/
