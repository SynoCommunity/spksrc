PKG_NAME = bicbucstriim-styles
PKG_VERS = 4.2.1
PKG_EXT = tar.gz
PKG_GIT_TAG = v$(PKG_VERS)
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/mikespub-org/rvolz-BicBucStriim.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_TAG).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_TAG)

DEPENDS =

HOMEPAGE = https://github.com/mikespub-org/rvolz-BicBucStriim/
COMMENT  = Stylesheet parts omitted from the BicBucStriim 4.2.1 release zip.
LICENSE  = MIT

INSTALL_TARGET = bicbucstriim_styles_install

include ../../mk/spksrc.cross-install.mk

.PHONY: bicbucstriim_styles_install
bicbucstriim_styles_install:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/share/bbs/style
	@cp -a $(WORK_DIR)/$(PKG_DIR)/style/parts $(STAGING_INSTALL_PREFIX)/share/bbs/style/
	@cp -a $(WORK_DIR)/$(PKG_DIR)/style/darksoha $(STAGING_INSTALL_PREFIX)/share/bbs/style/
