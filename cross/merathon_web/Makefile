PKG_NAME = merathon_web
PKG_VERS = 2.19.0
PKG_EXT = tar.gz
PKG_DIST_NAME = merathon-web-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/J-Dudek/merathon/releases/download/v$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/J-Dudek/merathon
COMMENT = Web interface of Merathon (React), built by the project's release workflow (npm run build:server).
LICENSE = MIT

INSTALL_TARGET = merathon_web_install

include ../../mk/spksrc.cross-install.mk

.PHONY: merathon_web_install
merathon_web_install:
	@$(MSG) Move the web interface of Merathon into web
	mv -f $(WORK_DIR)/web $(STAGING_INSTALL_PREFIX)
