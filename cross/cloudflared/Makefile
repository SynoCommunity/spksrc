PKG_NAME = cloudflared
PKG_VERS = 2024.1.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/cloudflare/cloudflared/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://github.com/cloudflare/cloudflared
COMMENT  = Cloudflare Tunnel client (formerly Argo Tunnel)
LICENSE  = Apache-2.0

GO_SRC_DIR = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)
COMPILE_TARGET = install-go cloudflared_compile

include ../../mk/spksrc.cross-go.mk

.PHONY: cloudflared_compile
cloudflared_compile:
	@$(RUN) $(MAKE) PATH="/tmp/go/bin:${PATH}" VERSION=$(PKG_VERS) LINK_FLAGS="-s -w" cloudflared

.PHONY: install-go
install-go:
ifeq (,$(wildcard /tmp/go))
	$(RUN) GOARCH= GOOS= GOROOT_BOOTSTRAP=$(WORK_DIR)/../../../native/go/work-native/go/ \
	$(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/.teamcity/install-cloudflare-go.sh
endif
