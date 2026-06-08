PKG_NAME = loom
PKG_VERS = 0.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-source-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Ebenderooock/loom/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

BUILD_DEPENDS = native/go

HOMEPAGE = https://loom.deroock.co.za
COMMENT  = Loom is a unified, self-hosted media automation server (a Radarr/Sonarr/Prowlarr/Overseerr replacement).
LICENSE  = AGPL-3.0

# Compiled binary lives at the root of the extracted source tree.
GO_SRC_DIR = $(EXTRACT_PATH)
GO_BIN_DIR = $(EXTRACT_PATH)/loom
COMPILE_TARGET = loom_compile

include ../../mk/spksrc.cross-go.mk

# Loom uses the pure-Go modernc.org/sqlite driver, so CGO is disabled and no C
# cross-toolchain is required. The web UI is compiled into the binary via the
# `embed` build tag; the prebuilt web/dist/ is shipped inside the curated
# loom-source-v<version>.tar.gz release asset, so no Node toolchain is needed.
.PHONY: loom_compile
loom_compile:
	@$(MSG) Compile loom $(PKG_VERS) for $(GOOS)/$(GO_ARCH) with embedded web UI
	cd $(GO_SRC_DIR) && env $(ENV) CGO_ENABLED=0 \
		go build -trimpath -tags embed -ldflags "-s -w \
		-X github.com/ebenderooock/loom/internal/buildinfo.Version=$(PKG_VERS)" \
		-o loom ./cmd/loom
