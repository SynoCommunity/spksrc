PKG_NAME = beszel-agent
REAL_PKG_NAME = beszel
PKG_VERS = 0.18.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/henrygd/beszel/archive/refs/tags
PKG_DIST_FILE = $(REAL_PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

PKG_DIR = $(PKG_NAME)/$(REAL_PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)

BUILD_DEPENDS = native/go

HOMEPAGE = https://beszel.dev/
COMMENT  = Simple, lightweight server monitoring agent.
LICENSE  = MIT

COMPILE_MAKE_OPTIONS = OS=$(GOOS) ARCH=$(GO_ARCH) build-agent
INSTALL_TARGET = install_beszel

include ../../mk/spksrc.cross-go.mk

.PHONY: install_beszel
install_beszel:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/build/beszel-agent $(STAGING_INSTALL_PREFIX)/bin/
