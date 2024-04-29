PKG_NAME = fritzctl
PKG_VERS = 1.4.23
PKG_ORG = bpicode
PKG_IMPORT_PATH = github.com/$(PKG_ORG)/$(PKG_NAME)
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://$(PKG_IMPORT_PATH)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/$(PKG_ORG)
PKG_DIR = $(PKG_NAME)

BUILD_DEPENDS = native/go

HOMEPAGE = https://$(PKG_IMPORT_PATH)
COMMENT  = fritzctl is a command line client for the AVM FRITZ!Box primarily focused on the AVM Home Automation HTTP Interface.
LICENSE  = MIT

POST_EXTRACT_TARGET = fritzctl_post_extract

GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)
GO_LDFLAGS = -s -w -X github.com/bpicode/fritzctl/config.Version=$(PKG_VERS)
# use GOPATH within workdir
GOPATH=$(WORK_DIR)

include ../../mk/spksrc.cross-go.mk

.PHONY: fritzctl_post_extract
fritzctl_post_extract:
	cd $(EXTRACT_PATH) && mv $(PKG_NAME)-$(PKG_VERS) $(PKG_NAME)
