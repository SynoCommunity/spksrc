PKG_NAME = beszel-hub
REAL_PKG_NAME = beszel
PKG_VERS = 0.21.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/henrygd/beszel/archive
PKG_DIST_FILE = $(REAL_PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

# use different folders for beszel-agent and beszel-hub
PKG_DIR = $(PKG_NAME)/$(REAL_PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)

BUILD_DEPENDS = native/nodejs
# native/go is used to install go version defined in go.mod
MIN_GO_VERSION = 1.24

HOMEPAGE = https://beszel.dev/
COMMENT  = Simple, lightweight server monitoring.
LICENSE  = MIT

COMPILE_ARGS = build-hub

INSTALL_TARGET = install_beszel

include ../../mk/spksrc.cross-go.mk

ENV += PATH=$(realpath $(WORK_DIR)/../../../native/nodejs/work-native/node/bin):$(GO_NATIVE_PATH):$(PATH)

.PHONY: install_beszel
install_beszel:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/build/beszel $(STAGING_INSTALL_PREFIX)/bin/
