PKG_NAME = lua
PKG_VERS = 5.2.3
PKG_EXT = tar.gz
PKG_DIST_NAME = lua-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.lua.org/ftp
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

HOMEPAGE = http://www.lua.org/
COMMENT  = Free general-purpose data compression software with high compression ratio
LICENSE  = MIT

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	@$(RUN) $(MAKE) generic

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install INSTALL_TOP=$(INSTALL_DIR)/$(INSTALL_PREFIX)/
