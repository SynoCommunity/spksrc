PKG_NAME = dsm-dark-mode
PKG_VERS = 1.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/SoulInfernoDE/synology-dsm-dark-mode/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = synology-dsm-dark-mode-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/SoulInfernoDE/synology-dsm-dark-mode
COMMENT  = Dark theme for the DSM 7 desktop, generated on the NAS from the stylesheets DSM loads.
LICENSE  = GPL-3.0

INSTALL_TARGET = dsm-dark-mode_install

include ../../mk/spksrc.cross-install.mk

# build.sh --stage installs the package files (generator, desktop script,
# stylesheet placeholder) without building the project's own SPK.
.PHONY: dsm-dark-mode_install
dsm-dark-mode_install:
	cd $(WORK_DIR)/$(PKG_DIR) && ./build.sh --stage $(STAGING_INSTALL_PREFIX)
