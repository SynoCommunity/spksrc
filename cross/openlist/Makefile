PKG_NAME = OpenList
PKG_VERS = 4.0.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenListTeam/OpenList/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs native/go

# lacking support for atomics
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)
# not supported by go
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

HOMEPAGE = https://docs.oplist.org/
COMMENT  = A file list program that supports multiple storages, powered by Gin and SolidJS, fork of AList.
LICENSE = AGPL-3.0

PRE_COMPILE_TARGET = openlist_pre_compile

WEB_VERSION = dev
NODE_BIN = $(realpath $(WORK_DIR)/../../../native/nodejs/work-native/install/usr/local/bin)
ENV += PATH="$(PATH):$(NODE_BIN)"

BUILT_AT = $(shell date +'%F %T %z')
# set SynoCommunity as git author
GIT_AUTHOR = "SynoCommunity/spksrc"
# git commit of SynoCommunity/spksrc repo
GIT_COMMIT = $(shell git log --pretty=format:"%h" -1)

CGO_ENABLED = 1
GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/openlist
GO_LDFLAGS = -w -s \
  -X 'github.com/OpenListTeam/OpenList/internal/conf.BuiltAt=$(BUILT_AT)' \
  -X 'github.com/OpenListTeam/OpenList/internal/conf.GitAuthor=$(GIT_AUTHOR)' \
  -X 'github.com/OpenListTeam/OpenList/internal/conf.GitCommit=$(GIT_COMMIT)' \
  -X 'github.com/OpenListTeam/OpenList/internal/conf.Version=$(PKG_VERS)' \
  -X 'github.com/OpenListTeam/OpenList/internal/conf.WebVersion=$(WEB_VERSION)'

include ../../mk/spksrc.cross-go.mk

.PHONY: openlist_pre_compile
openlist_pre_compile:
	@$(MSG) "- Build web frontend"
	@$(RUN) ; bash build.sh $(WEB_VERSION) web
