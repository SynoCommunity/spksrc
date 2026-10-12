PKG_NAME = duplicatefinder
PKG_VERS = 1.1.2
PKG_EXT = tar.gz
# `digests` holds the hashes of the archive GitHub serves for tag v$(PKG_VERS)
# (archive/refs/tags/v$(PKG_VERS).tar.gz); regenerate it with `make digests`
# whenever PKG_VERS changes.
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/A5HRAJ/duplicatefinder/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Go has no PPC target, and ARMv5 is not a target of this package.
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

BUILD_DEPENDS = native/go
# tools/make_icons.py needs only the Python standard library; the spksrc
# build image ships python3 (and jq), so no native/python3xx dependency.

HOMEPAGE = https://github.com/A5HRAJ/duplicatefinder
COMMENT  = Find duplicate, conflicting, empty and junk files on a Synology NAS from a native DSM desktop app.
LICENSE  = MIT

# The Go module lives in server/; everything else in the archive is the DSM
# UI, the package scripts and the icon generator.
GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/server
GO_BIN_DIR = $(GO_SRC_DIR)/dupfinder
# -X stamps the version into the daemon so /api/info can answer "which build
# is live?" without going through Package Center. The spk revision is not
# visible here, so the daemon reports PKG_VERS alone.
GO_LDFLAGS = -s -w -X main.appVersion=$(PKG_VERS)
GO_BUILD_ARGS = -trimpath

INSTALL_TARGET = duplicatefinder_install

include ../../mk/spksrc.cross-go.mk

# Stage bin/dupfinder plus the UI tree and icons under share/, so the spk
# picks them up through the PLIST. The spk Makefile moves ui/ and the icons
# into place and applies the UI cache stamp (see spk/duplicatefinder/Makefile).
.PHONY: duplicatefinder_install
duplicatefinder_install:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(GO_BIN_DIR) $(STAGING_INSTALL_PREFIX)/bin/
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/icons
	@cp -R $(WORK_DIR)/$(PKG_DIR)/spk/ui $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/ui
	@find $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/ui -name '.DS_Store' -delete
	@python3 $(WORK_DIR)/$(PKG_DIR)/tools/make_icons.py $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)/icons >/dev/null
