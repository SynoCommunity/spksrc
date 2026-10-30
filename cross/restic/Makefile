PKG_NAME = restic
PKG_VERS = 0.19.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/restic/restic/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)

# A client: it never calls accept4, which go 1.24 and later need from Linux 3.2, so it runs
# on the ARMv5 2.6.32 kernel (tested on a DS212j).
MIN_KERNEL_VERSION =

HOMEPAGE = https://restic.net/
COMMENT  = Restic is a fast and secure backup program.
LICENSE  = BSD 2-Clause License

POST_EXTRACT_TARGET = restic_post_extract
COMPILE_TARGET = restic_compile

GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk

BUILD_ARGS = --goos $(GOOS) --goarch $(GO_ARCH)
# build.go resets GOARM, which go then defaults to 7
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
BUILD_ARGS += --goarm 5
endif

.PHONY: restic_post_extract
restic_post_extract:
	cd $(EXTRACT_PATH) && [ -d $(PKG_DIR)-$(PKG_VERS) ] && mv $(PKG_DIR)-$(PKG_VERS) $(PKG_NAME)

restic_compile:
	cd $(GO_SRC_DIR) && env $(filter-out GOARCH=%, $(ENV)) go run build.go $(BUILD_ARGS)
