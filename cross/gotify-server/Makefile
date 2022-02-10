PKG_NAME = gotify-server
PKG_VERS = 2.1.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gotify/server/archive
PKG_DIST_FILE = ${PKG_NAME}-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = server-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs native/go

HOMEPAGE = https://gotify.net/
COMMENT  = a simple server for sending and receiving messages
LICENSE  = MIT

GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)


PRE_COMPILE_TARGET = gotify_pre_compile

CGO_ENABLED = 1
GO_BUILD_ARGS += -ldflags "-w -s -X main.Version=$(PKG_VERS) -X main.BuildDate=$(shell date "+%F-%T") -X main.Commit=$(PKG_VERS) -X main.Mode=prod"

include ../../mk/spksrc.cross-go.mk

ENV += NPM_CONFIG_USER=root
PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)

.PHONY: gotify_pre_compile
gotify_pre_compile:
	cd $(GO_SRC_DIR)/ui && npm install && npm run build
	cd $(GO_SRC_DIR) && env $(filter-out GOARCH=%, $(ENV)) go run hack/packr/packr.go
