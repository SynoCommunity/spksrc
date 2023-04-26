PKG_NAME = syncthing-tech-ui
PKG_REAL_NAME = tech-ui
PKG_VERS = 1.0.0
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_REAL_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/syncthing/tech-ui/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_REAL_NAME)-v$(PKG_VERS)

# Remarks:
# The repository https://github.com/syncthing/tech-ui is archived
# Current development is in https://github.com/syncthing/syncthing/tree/main/next-gen-gui
# but there are no downloadable releases for tech-ui in the syncthing repository.
#
# Until otherwise requested, we take the only official release published on Apr 17, 2020.
#

HOMEPAGE = https://github.com/syncthing/syncthing/tree/main/next-gen-gui
COMMENT  = Alternative, stripped down status UI for large setups.
LICENSE  = MPL-2.0

INSTALL_TARGET = syncthing-tech-ui_install

include ../../mk/spksrc.install-resources.mk

.PHONY: syncthing-tech-ui_install
syncthing-tech-ui_install:
	@$(MSG) Install tech-ui
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/gui/default/tech-ui
	@tar -cf - -C $(WORK_DIR)/tech-ui . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/gui/default/tech-ui
