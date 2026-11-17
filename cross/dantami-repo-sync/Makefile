PKG_NAME = dantami-repo-sync
PKG_VERS = 1.6.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/momopanda123/$(PKG_NAME)/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go
HOMEPAGE = https://github.com/momopanda123/dantami-repo-sync
COMMENT = GitHub and Gitea repository synchronization with a web dashboard.
LICENSE = MIT

GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/repo-sync
GO_LDFLAGS = -s -w
GO_BUILD_ARGS = -trimpath

POST_INSTALL_TARGET = dantami_install_notices

include ../../mk/spksrc.cross-go.mk

# Do not silently download another Go toolchain during the build.
ENV += GOTOOLCHAIN=local

.PHONY: dantami_install_notices
dantami_install_notices:
	cd $(GO_SRC_DIR) && env $(ENV) go list -m -f '{{if .Dir}}{{.Path}} {{.Dir}}{{end}}' all > $(WORK_DIR)/dantami-modules.txt
	install -d -m 755 $(STAGING_INSTALL_PREFIX)/share/licenses/dantami-repo-sync
	install -m 644 $(WORK_DIR)/../../../native/go/work-native/go/LICENSE $(STAGING_INSTALL_PREFIX)/share/licenses/dantami-repo-sync/GO-LICENSE
	while read -r module directory; do \
	  test -n "$${directory}" || continue; \
	  destination="$(STAGING_INSTALL_PREFIX)/share/licenses/dantami-repo-sync/$${module}"; \
	  install -d -m 755 "$${destination}" || exit 1; \
	  for file in "$${directory}"/LICENSE* "$${directory}"/COPYING* "$${directory}"/NOTICE*; do \
	    test -f "$${file}" || continue; \
	    install -m 644 "$${file}" "$${destination}/" || exit 1; \
	  done; \
	done < $(WORK_DIR)/dantami-modules.txt
