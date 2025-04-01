PKG_NAME = gdu
PKG_VERS = 5.30.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dundee/gdu/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://github.com/dundee/gdu
COMMENT  = Fast disk usage analyzer with console interface written in Go.
LICENSE  = MIT

COMPILE_TARGET = gdu_compile
INSTALL_TARGET = gdu_install

include ../../mk/spksrc.cross-go.mk

.PHONY: gdu_compile
gdu_compile:
	@$(RUN) VERSION=$(PKG_VERS) $(MAKE) build

.PHONY: gdu_install
gdu_install:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin/
	@$(RUN) ; install -m 755 dist/gdu $(STAGING_INSTALL_PREFIX)/bin/
