PKG_NAME = gdu
PKG_VERS = 5.31.0
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dundee/gdu/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

UNSUPPORTED_ARCHS = $(PPC_ARCHS)
include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
BUILD_DEPENDS = native/go_1.23
NATIVE_GO = native/go_1.23
else
BUILD_DEPENDS = native/go
NATIVE_GO = native/go
endif

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
