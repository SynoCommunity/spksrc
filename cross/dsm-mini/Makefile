PKG_NAME = dsm-mini
PKG_VERS = 1.0.13
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/alexlnos/dsm-mini/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

# lacking support for atomics
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)
# not supported by go
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

HOMEPAGE = https://github.com/alexlnos/dsm-mini
COMMENT  = Telegram bot with a Mini App to manage a Synology NAS: downloads, files, disks, virtual machines and containers.
LICENSE  = MIT

COMPILE_TARGET = dsm-mini_compile
INSTALL_TARGET = dsm-mini_install

include ../../mk/spksrc.cross-go.mk

# The Mini App is built upstream and committed to the source tree, so it goes
# into the binary through go:embed without a Node toolchain here. The binary
# is pure Go (SQLite through modernc.org/sqlite), hence CGO stays off.
.PHONY: dsm-mini_compile
dsm-mini_compile:
	@$(RUN) env CGO_ENABLED=0 go build -trimpath \
		-ldflags "-s -w -X main.version=$(PKG_VERS)" \
		-o dsm-mini ./cmd/dsm-mini

.PHONY: dsm-mini_install
dsm-mini_install:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/dsm-mini $(STAGING_INSTALL_PREFIX)/bin/
