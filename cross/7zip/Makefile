PKG_NAME = 7z
PKG_VERS = 24.09
PKG_EXT = 7z
PKG_DIST_NAME = $(PKG_NAME)$(subst .,,$(PKG_VERS))-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ip7z/7zip/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)/CPP/7zip/Bundles/Alone2

EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)

DEPENDS =

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

HOMEPAGE = https://www.7-zip.org/
COMMENT  = 7-Zip is a file archiver with a high compression ratio.
LICENSE = https://github.com/ip7z/7zip/blob/main/DOC/License.txt

CONFIGURE_TARGET = nop
COMPILE_MAKE_OPTIONS = -f makefile.gcc

INSTALL_TARGET = 7z_install

PRE_DOWNLOAD_TARGET = install_p7zip

include ../../mk/spksrc.cross-cc.mk

.PHONY: 7z_install
7z_install:
	@$(MSG) install target files
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@install -m744 $(WORK_DIR)/$(PKG_DIR)/_o/7zz $(STAGING_INSTALL_PREFIX)/bin

.PHONY: install_p7zip
install_p7zip:
	@$(MSG) "Install p7zip (must be added to Dockerfile)"
	sudo apt-get update
	sudo apt-get install p7zip
