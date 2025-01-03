PKG_NAME = 7za
PKG_VERS = 24.09
PKG_EXT = tar.xz
PKG_DIST_NAME = 7z$(subst .,,$(PKG_VERS))-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ip7z/7zip/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)/CPP/7zip/Bundles/Alone

# source archive does not have a package named top folder
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

include ../../mk/spksrc.cross-cc.mk

.PHONY: 7z_install
7z_install:
	@$(MSG) install target file
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@install -m744 $(WORK_DIR)/$(PKG_DIR)/_o/7za $(STAGING_INSTALL_PREFIX)/bin

