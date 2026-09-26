PKG_NAME = smart-optimizer-ui
PKG_VERS = 2.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MrRobot-88/Smart-Optimizer-UI/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = Smart-Optimizer-UI-$(PKG_VERS)

HOMEPAGE = https://github.com/MrRobot-88/Smart-Optimizer-UI
COMMENT = Web UI and optimizer engines for Radarr and Sonarr
LICENSE = MIT

INSTALL_TARGET = smart_optimizer_ui_install

include ../../mk/spksrc.cross-install.mk

.PHONY: smart_optimizer_ui_install

smart_optimizer_ui_install:
	@install -d $(STAGING_INSTALL_PREFIX)/share/smartoptimizerui
	@cp -p $(EXTRACT_PATH)/smart-optimizer-ui.py $(STAGING_INSTALL_PREFIX)/share/smartoptimizerui/
	@cp -p $(EXTRACT_PATH)/radarr-smart-optimizer.py $(STAGING_INSTALL_PREFIX)/share/smartoptimizerui/
	@cp -p $(EXTRACT_PATH)/sonarr-smart-optimizer.py $(STAGING_INSTALL_PREFIX)/share/smartoptimizerui/
	@cp -a $(EXTRACT_PATH)/assets $(STAGING_INSTALL_PREFIX)/share/smartoptimizerui/
	@sed -i 's/const SMART_ADMIN_DEVELOPMENT_BUILD = true;/const SMART_ADMIN_DEVELOPMENT_BUILD = false;/' $(STAGING_INSTALL_PREFIX)/share/smartoptimizerui/assets/fragments/admin-update-mode.html
	@grep -q '^def download_latest_update():$$' $(STAGING_INSTALL_PREFIX)/share/smartoptimizerui/smart-optimizer-ui.py || (echo "ERROR: download_latest_update() not found; refusing to build with self-update potentially enabled." >&2; exit 1)
	@sed -i '/^def download_latest_update():$$/a\    raise RuntimeError("Self-update is disabled for the SynoCommunity package. Use Synology Package Center to update Smart Optimizer UI.")' $(STAGING_INSTALL_PREFIX)/share/smartoptimizerui/smart-optimizer-ui.py
