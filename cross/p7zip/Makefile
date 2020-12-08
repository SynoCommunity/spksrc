PKG_NAME = p7zip
PKG_VERS = 16.02
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS)_src_all.$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)_$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.7-zip.org/
COMMENT  = 7-Zip is a file archiver with a high compression ratio.
LICENSE  = https://www.7-zip.org/license.txt

CONFIGURE_TARGET = nop
COMPILE_TARGET = p7zip_compile
INSTALL_TARGET = p7zip_install
OFLAG = -O3

GNU_CONFIGURE = 1
CONFIGURE_ARGS =

include ../../mk/spksrc.cross-cc.mk

.PHONY: p7zip_compile
p7zip_compile:
	@$(RUN) $(MAKE) all3 CC="$(TC_PATH)$(TC_PREFIX)gcc \$$(ALLFLAGS) $(OFLAG)" CXX="$(TC_PATH)$(TC_PREFIX)g++ \$$(ALLFLAGS) $(OFLAG)" CPPFLAGS="$(CPPFLAGS)" LDFLAGS="$(LDFLAGS)"

.PHONY: p7zip_install
p7zip_install:
	@$(RUN) $(MAKE) install DEST_DIR=$(INSTALL_DIR) DEST_HOME=$(INSTALL_PREFIX)
