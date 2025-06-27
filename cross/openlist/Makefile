PKG_NAME = openlist
PKG_VERS = 4.0.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenListTeam/OpenList/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = OpenList-$(PKG_VERS)

DEPENDS = native/nodejs native/go

COMPILE_TARGET = openlist_build
INSTALL_TARGET   = openlist_install


include ../../mk/spksrc.cross-go.mk

BUILD_DATE = $(shell date -u +%Y-%m-%dT%H:%M:%SZ)

NODE_BIN = $(realpath $(WORK_DIR)/../../../native/nodejs/work-native/install/usr/local/bin)
GO_BIN = $(realpath $(WORK_DIR)/../../../native/go/work-native/go/bin)


GO_SRC_PATH = github.com/OpenListTeam/OpenList
GO_LDFLAGS = \
  -X '$(GO_SRC_PATH)/internal/conf.BuiltAt=$(BUILD_DATE)' \
  -X '$(GO_SRC_PATH)/internal/conf.GitAuthor=OpenList' \
  -X '$(GO_SRC_PATH)/internal/conf.GitCommit=$(PKG_VERS)' \
  -X '$(GO_SRC_PATH)/internal/conf.Version=$(PKG_VERS)' \
  -X '$(GO_SRC_PATH)/internal/conf.WebVersion=dev'

.PHONY: openlist_build
openlist_build:
	@$(MSG) "Building web frontend…"
	cd $(WORK_DIR)/$(PKG_DIR) && env PATH="$(PATH):$(NODE_BIN)" bash build.sh dev web
	@$(MSG) "Building Go binary…"
	cd $(WORK_DIR)/$(PKG_DIR) && \
	  env PATH="$(PATH):$(GO_BIN)" GOARCH=$(GO_ARCH) CGO_ENABLED=1 go build \
	    -ldflags "$(GO_LDFLAGS)" \
	    -o openlist .

.PHONY: openlist_install
openlist_install:
	@$(MSG) "Installing openlist to staging…"
	install -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/openlist \
	                $(STAGING_INSTALL_PREFIX)/bin/
