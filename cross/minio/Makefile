PKG_NAME = minio
PKG_VERS = 2020-11-25T22-36-25Z
PKG_EXT = tar.gz
PKG_DIST_PREFIX = RELEASE.$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIST_PREFIX).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/minio/minio/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_DIST_PREFIX)

DEPENDS = native/go

HOMEPAGE = https://min.io/
COMMENT  = MinIO is a high performance object storage server compatible with Amazon S3 APIs.
LICENSE  = Apache License 2.0

POST_EXTRACT_TARGET = minio_post_extract


GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

ENV += GO111MODULE=on

GO_BUILD_ARGS = -tags kqueue

GO_LDFLAGS  = -s -w
GO_LDFLAGS += -X github.com/minio/minio/cmd.Version=$(PKG_VERS)
GO_LDFLAGS += -X github.com/minio/minio/cmd.ReleaseTag=$(PKG_VERS)

include ../../mk/spksrc.cross-go.mk


# rename extracted folder to make imports work when used as GOPATH
minio_post_extract:
	cd $(EXTRACT_PATH) && [ -d $(PKG_DIR) ] && mv $(PKG_DIR) $(PKG_NAME)
