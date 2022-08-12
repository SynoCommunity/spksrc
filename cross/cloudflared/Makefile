PKG_NAME = cloudflared
PKG_VERS = 2022.8.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/cloudflare/cloudflared/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://github.com/cloudflare/cloudflared
COMMENT  = Cloudflare Tunnel client (formerly Argo Tunnel)
LICENSE  = Apache-2.0

GO_SRC_DIR = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)
COMPILE_TARGET = cloudflared_compile

include ../../mk/spksrc.cross-go.mk

.PHONY: cloudflared_compile
cloudflared_compile:
	@$(RUN) $(MAKE) VERSION=$(PKG_VERS) LINK_FLAGS="-s -w" cloudflared
