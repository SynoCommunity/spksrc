PKG_NAME = ente
PKG_VERS = 1.7.14
PKG_EXT = tar.gz
PKG_DIST_NAME = photosd-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ente-io/ente/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-photosd-v$(PKG_VERS)

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)

DEPENDS = cross/libsodium
BUILD_DEPENDS = native/go

HOMEPAGE = https://ente.io/
COMMENT  = End-to-end encrypted platform for photos and authenticators
LICENSE  = AGPLv3

CGO_ENABLED = 1
COMPILE_TARGET = ente_compile_target
INSTALL_TARGET = ente_install_target

# Go source is in server subdirectory

export EXTRA_GOFLAGS=-buildvcs=false

include ../../mk/spksrc.cross-go.mk

ENV += CGO_ENABLED=1
ENV += CGO_CFLAGS=-I$(STAGING_INSTALL_PREFIX)/include
ENV += CGO_LDFLAGS=-L$(STAGING_INSTALL_PREFIX)/lib

.PHONY: ente_compile_target
ente_compile_target:
	@cd $(WORK_DIR)/$(PKG_DIR)/server && env $(ENV) go build -o ../museum cmd/museum/main.go

.PHONY: ente_install_target
ente_install_target:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/server
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/museum $(STAGING_INSTALL_PREFIX)/bin/
	@cp -r $(WORK_DIR)/$(PKG_DIR)/server/configurations $(STAGING_INSTALL_PREFIX)/share/server/
	@cp -r $(WORK_DIR)/$(PKG_DIR)/server/migrations $(STAGING_INSTALL_PREFIX)/share/server/
	@cp -r $(WORK_DIR)/$(PKG_DIR)/server/mail-templates $(STAGING_INSTALL_PREFIX)/share/server/
	@cp -r $(WORK_DIR)/$(PKG_DIR)/server/web-templates $(STAGING_INSTALL_PREFIX)/share/server/
	@echo "Patching migrations for PostgreSQL transaction limitations"
	@find $(STAGING_INSTALL_PREFIX)/share/server/migrations/ -name "*.up.sql" -exec sed -i '/ALTER TYPE.*ADD VALUE/d' {} \;
