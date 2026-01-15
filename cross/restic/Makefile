PKG_NAME = restic
PKG_VERS = 0.18.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/restic/restic/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)

BUILD_DEPENDS = native/go

HOMEPAGE = https://restic.net/
COMMENT  = Restic is a fast and secure backup program.
LICENSE  = BSD 2-Clause License

POST_EXTRACT_TARGET = restic_post_extract
COMPILE_TARGET = restic_compile

GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk

BUILD_ARGS = --goos $(GOOS) --goarch $(GO_ARCH)
ifdef $(GOARM)
	BUILD_ARGS += --goarm $(GOARM)
endif

.PHONY: restic_post_extract
restic_post_extract:
	cd $(EXTRACT_PATH) && [ -d $(PKG_DIR)-$(PKG_VERS) ] && mv $(PKG_DIR)-$(PKG_VERS) $(PKG_NAME)

restic_compile:
	cd $(GO_SRC_DIR) && env $(filter-out GOARCH=%, $(ENV)) go run build.go $(BUILD_ARGS)
