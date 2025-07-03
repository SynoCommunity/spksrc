PKG_NAME = openlist-frontend
# WARNING: 
# WEB_VERSION in cross/openlist/Makefile must match this version
PKG_VERS = 4.0.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-dist-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v$(PKG_VERS)/

EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)/dist

# download prebuilt frontend into dist folder
# nothing to install
INSTALL_TARGET = nop

HOMEPAGE = https://docs.oplist.org/
COMMENT = OpenList (frontend).
LICENSE = MIT

include ../../mk/spksrc.install-resources.mk
