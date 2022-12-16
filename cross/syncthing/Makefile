PKG_NAME = syncthing
PKG_VERS = 1.22.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-source-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/syncthing/syncthing/releases/download/v$(PKG_VERS)
PKG_DIR = src/github.com/$(PKG_NAME)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

BUILD_DEPENDS = native/go
# add node for "next gen gui"
BUILD_DEPENDS += native/nodejs

HOMEPAGE = https://www.syncthing.net/
COMMENT  = Syncthing is a continuous file synchronization program. It synchronizes files between two or more computers.
LICENSE  = MPL-2.0

COMPILE_TARGET = syncthing_compile
POST_INSTALL_TARGET = syncthing_post_install

GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

NATIVE_GO_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/go/work-native/go/bin)
NATIVE_NODE_BIN_DIR = $(realpath $(WORK_DIR)/../../../native/nodejs/work-native/node/bin)

include ../../mk/spksrc.cross-go.mk

# we need go and node in the path
ENV += PATH=$(NATIVE_GO_BIN_DIR):$(NATIVE_NODE_BIN_DIR):$$PATH

BUILD_ARGS  = -goos=$(GOOS) -goarch=$(GO_ARCH) -version=v$(PKG_VERS)
BUILD_ARGS += --with-next-gen-gui

# use custom build to remove GOARCH from ENV and for custom BUILD_ARGS
syncthing_compile:
	cd $(GO_SRC_DIR) && env $(filter-out GOARCH=%, $(ENV)) go run build.go $(BUILD_ARGS) build

.PHONY: syncthing_post_install
syncthing_post_install:
	@$(MSG) Install next-gen-gui
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/gui/default/tech-ui
	@tar -cf - -C $(GO_SRC_DIR)/next-gen-gui/dist/next-gen-gui . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/gui/default/tech-ui
