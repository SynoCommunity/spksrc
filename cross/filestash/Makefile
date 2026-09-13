PKG_NAME = filestash
# No upstream tags; pinned to master commit below (commit date as version)
PKG_VERS = 20260910
PKG_GIT_HASH = 8a85e85bf2afa4007b62a53cbe2b57e4c3bb1551
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mickael-kerjean/filestash/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

BUILD_DEPENDS = native/go

# Go 1.26 has no 32-bit PowerPC target (covered by env-go.mk);
# ARMv5 (88f6281, kernel 2.6) is below Go's minimum kernel needs
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)

HOMEPAGE = https://filestash.app
COMMENT  = Web file manager with SFTP, S3, WebDAV and cloud backends.
LICENSE  = AGPL-3.0

# NOTE: no package path here: env-go.mk appends -buildvcs=false after
# GO_BUILD_ARGS, and Go stops flag parsing at the first positional arg,
# so the package must be selected via GO_SRC_DIR instead (builds ".").
GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/cmd
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/dist/filestash
GO_BUILD_ARGS = -tags "fts5" -o $(WORK_DIR)/$(PKG_DIR)/dist/filestash

PRE_COMPILE_TARGET = filestash_pre_compile

include ../../mk/spksrc.cross-go.mk

.PHONY: filestash_pre_compile
filestash_pre_compile:
	# Upstream CI builds with CGO_ENABLED=0 (env-go.mk default); use the
	# pure-Go image plugin like they do (see Jenkinsfile)
	@cd $(WORK_DIR)/$(PKG_DIR) && sed -i 's|plg_image_c|plg_image_golang|' server/plugin/index.go
	@cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) go generate ./server/...
