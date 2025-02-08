PKG_NAME = cloudflared
PKG_VERS = 2025.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/cloudflare/cloudflared/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://github.com/cloudflare/cloudflared
COMMENT  = Cloudflare Tunnel provides you with a secure way to connect your resources to Cloudflare without a publicly routable IP address.
LICENSE  = Apache-2.0

GO_SRC_DIR = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)
COMPILE_TARGET = cloudflared_compile

include ../../mk/spksrc.cross-go.mk

GOROOT_BOOTSTRAP=$(WORK_DIR)/../../../native/go/work-native/go/

.PHONY: cloudflared_compile
cloudflared_compile:
ifeq (,$(wildcard /tmp/go))
	@$(MSG) "- Call install-cloudflare-go.sh"
	@$(RUN) GOARCH= GOOS= GOROOT_BOOTSTRAP=$(GOROOT_BOOTSTRAP) .teamcity/install-cloudflare-go.sh
endif
	@$(MSG) "- Build cloudflared"
	@$(RUN) $(MAKE) PATH="/tmp/go/bin:${PATH}" VERSION=$(PKG_VERS) LINK_FLAGS="-s -w" cloudflared
