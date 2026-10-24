PKG_NAME = advanced-acme
PKG_VERS = 0.1.10
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SoulInfernoDE/synology-advanced-acme/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = synology-advanced-acme-$(PKG_VERS)

DEPENDS = cross/acme.sh

HOMEPAGE = https://github.com/SoulInfernoDE/synology-advanced-acme
COMMENT  = Automatic SSL certificates for DSM (IONOS SSL, Let's Encrypt, ZeroSSL) with acme.sh and DNS validation.
LICENSE  = GPL-3.0

INSTALL_TARGET = advanced-acme_install

include ../../mk/spksrc.cross-install.mk

# build.sh --stage installs the program files next to the acme.sh from
# cross/acme.sh (it adds the DSM deploy hook and generates the DNS plugin
# list). ACME_UPDATES=0: acme.sh is updated only with this package, the
# optional acme.sh downloads from the interface are left out.
.PHONY: advanced-acme_install
advanced-acme_install:
	cd $(WORK_DIR)/$(PKG_DIR) && ACME_UPDATES=0 ./build.sh --stage $(STAGING_INSTALL_PREFIX)
