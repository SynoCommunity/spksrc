PKG_NAME = syncthing
PKG_VERS = 1.27.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-source-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/syncthing/syncthing/releases/download/v$(PKG_VERS)
PKG_DIR = src/github.com/$(PKG_NAME)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

BUILD_DEPENDS = native/go

HOMEPAGE = https://www.syncthing.net/
COMMENT  = Syncthing is a continuous file synchronization program. It synchronizes files between two or more computers.
LICENSE  = MPL-2.0

COMPILE_TARGET = syncthing_compile

GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk

BUILD_ARGS = -goos=$(GOOS) -goarch=$(GO_ARCH) -version=v$(PKG_VERS)

.PHONY: syncthing_compile
# use custom build to remove GOARCH from ENV and for custom BUILD_ARGS
syncthing_compile:
	cd $(GO_SRC_DIR) && env $(filter-out GOARCH=%, $(ENV)) go run build.go $(BUILD_ARGS) build
