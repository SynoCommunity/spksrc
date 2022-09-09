PKG_NAME = minio-client
REAL_PKG_NAME = mc
PKG_VERS = 2022-08-28T20-08-11Z
PKG_RELEASE_TAG = $(subst :,-,$(PKG_VERS))
PKG_COMMIT_ID = a64491e101feeaf68735a20c204d06993ba531e5
PKG_EXT = tar.gz
PKG_DIST_PREFIX = RELEASE.$(PKG_RELEASE_TAG)
PKG_DIST_NAME = $(PKG_DIST_PREFIX).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/minio/mc/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/$(REAL_PKG_NAME)
PKG_DIR = $(REAL_PKG_NAME)-$(PKG_DIST_PREFIX)

BUILD_DEPENDS = native/go

HOMEPAGE = https://min.io/
COMMENT  = MinIO Client (mc) provides a modern alternative to UNIX commands like ls, cat, cp, mirror, diff, find etc. It supports filesystems and Amazon S3 compatible cloud storage service (AWS Signature v2 and v4).
LICENSE  = AGPLv3.0

POST_EXTRACT_TARGET = minio-client_post_extract
POST_INSTALL_TARGET = minio-client_post_install

GO_SRC_DIR = $(EXTRACT_PATH)/$(REAL_PKG_NAME)
GO_BIN_DIR = $(GO_SRC_DIR)/$(REAL_PKG_NAME)

ENV += GO111MODULE=on

GO_BUILD_ARGS = -tags kqueue

GO_LDFLAGS  = -s -w
GO_LDFLAGS += -X github.com/minio/mc/cmd.ReleaseTag=$(PKG_RELEASE_TAG)
GO_LDFLAGS += -X github.com/minio/mc/cmd.CopyrightYear=$(firstword $(subst -, ,$(PKG_VERS)))
GO_LDFLAGS += -X github.com/minio/mc/cmd.CommitID=$(PKG_COMMIT_ID)

include ../../mk/spksrc.cross-go.mk

# rename extracted folder to make imports work when used as GOPATH
.PHONY: minio-client_post_extract
minio-client_post_extract:
	cd $(EXTRACT_PATH) && [ -d $(PKG_DIR) ] && mv $(PKG_DIR) $(REAL_PKG_NAME)

.PHONY: minio-client_post_install
minio-client_post_install:
	@$(MSG) Add minio-client link, as mc executable in path is midnight-commander
	@cd $(STAGING_INSTALL_PREFIX)/bin && ln -sf mc minio-client
