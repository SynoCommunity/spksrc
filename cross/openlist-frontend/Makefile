PKG_NAME = openlist-frontend
# WARNING: 
# WEB_VERSION in cross/openlist/Makefile must match this version
PKG_VERS = 4.1.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-dist-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v$(PKG_VERS)/

# download prebuilt frontend into dist folder
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)/dist
# nothing to install
INSTALL_TARGET = nop

HOMEPAGE = https://docs.oplist.org/
COMMENT = The front-end of OpenList, powered by SolidJS.
LICENSE = MIT

include ../../mk/spksrc.install-resources.mk
