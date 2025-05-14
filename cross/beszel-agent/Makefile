PKG_NAME = beszel-agent
REAL_PKG_NAME = beszel
PKG_VERS = 0.11.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/henrygd/beszel/archive
PKG_DIST_FILE = $(REAL_PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

# use different folders for baszel-agent and baszel-hub
PKG_DIR = $(PKG_NAME)/$(REAL_PKG_NAME)-$(PKG_VERS)/beszel
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)

BUILD_DEPENDS = native/go

HOMEPAGE = https://beszel.dev/
COMMENT  = Simple, lightweight server monitoring.
LICENSE  = MIT

COMPILE_MAKE_OPTIONS = build-agent

INSTALL_TARGET = install_beszel

include ../../mk/spksrc.cross-go.mk

.PHONY: install_beszel
install_beszel:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@install -m 744 $(WORK_DIR)/$(PKG_DIR)/build/beszel-agent $(STAGING_INSTALL_PREFIX)/bin/
