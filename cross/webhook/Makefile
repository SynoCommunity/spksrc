PKG_NAME = webhook
PKG_VERS = 2.8.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/adnanh/webhook/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://github.com/adnanh/webhook
COMMENT  = webhook is a lightweight incoming webhook server to run shell commands
LICENSE  = MIT

# go does not support ppc archs
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

COMPILE_TARGET = webhook_compile_target
INSTALL_TARGET = webhook_install

include ../../mk/spksrc.cross-go.mk

.PHONY: webhook_compile_target
webhook_compile_target:
	@$(RUN) go build -buildvcs=false -o webhook $(WORK_DIR)/$(PKG_DIR)

.PHONY: webhook_install
webhook_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/webhook $(STAGING_INSTALL_PREFIX)/bin/
