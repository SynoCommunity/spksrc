PKG_NAME = p7zip
PKG_VERS = 16.02
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS)_src_all.$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/p7zip/p7zip/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)_$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.7-zip.org/
COMMENT  = 7-Zip is a file archiver with a high compression ratio.
# License for 7za, as we build the 7za executable only:
LICENSE = LGPLv2.1+

CONFIGURE_TARGET = nop
INSTALL_TARGET = p7zip_install

COMPILE_MAKE_OPTIONS += CC="$(TC_PATH)$(TC_PREFIX)gcc"
COMPILE_MAKE_OPTIONS += CXX="$(TC_PATH)$(TC_PREFIX)g++"

include ../../mk/spksrc.cross-cc.mk

.PHONY: p7zip_install
p7zip_install:
	@$(RUN) $(MAKE) install DEST_DIR=$(INSTALL_DIR) DEST_HOME=$(INSTALL_PREFIX)
