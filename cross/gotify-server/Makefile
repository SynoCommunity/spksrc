PKG_NAME = gotify-server
PKG_VERS = 3.1.1
PKG_COMMIT = e6361caa512547052b1013dbf4544e6d7ff32604
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gotify/server/archive/refs/tags
PKG_DIST_FILE = gotify-server-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = server-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs

HOMEPAGE = https://gotify.net/
COMMENT  = A simple server for sending and receiving messages
LICENSE  = MIT

CGO_ENABLED = 1
GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/gotify-server
GO_BUILD_ARGS = -trimpath
BUILD_DATE = $(shell date -u -d @$(or $(SOURCE_DATE_EPOCH),$(shell date +%s)) +%Y-%m-%dT%H:%M:%SZ)
GO_LDFLAGS = -s -w -X main.Version=$(PKG_VERS) -X main.Commit=$(PKG_COMMIT) -X main.BuildDate=$(BUILD_DATE) -X main.Mode=prod

PRE_COMPILE_TARGET = gotify-server_pre_compile

include ../../mk/spksrc.cross-go.mk

PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)
# The UI lockfile is Yarn 1; pin it so Corepack does not switch to Yarn 2+.
YARN_VERSION = 1.22.22
ENV += COREPACK_ENABLE_DOWNLOAD_PROMPT=0
# Old toolchains (e.g. x64-5.2) fail with the host locale.
ENV += LC_ALL=C
# Go selects gold on aarch64; Synology's gold cannot link cgo.
ifeq ($(ARCH),aarch64)
ENV += CGO_LDFLAGS=-fuse-ld=bfd
endif

.PHONY: gotify-server_pre_compile
gotify-server_pre_compile:
	@$(MSG) "- Build Gotify UI"
	$(RUN) sh -c 'corepack prepare yarn@$(YARN_VERSION) --activate && cd ui && corepack yarn install --frozen-lockfile --non-interactive && corepack yarn build'
