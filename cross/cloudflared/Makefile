PKG_NAME = cloudflared
PKG_VERS = 2026.10.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/cloudflare/cloudflared/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

# ARMv5 (88f6281) runs kernel 2.6.32; go >= 1.24 requires Linux >= 3.2, so
# cloudflared built with the current go (1.27.2) cannot run there. v2025.5.0 was
# the last release that still built with go < 1.24.
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

HOMEPAGE = https://github.com/cloudflare/cloudflared
COMMENT  = Cloudflare Tunnel provides you with a secure way to connect your resources to Cloudflare without a publicly routable IP address.
LICENSE  = Apache-2.0

GO_SRC_DIR = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)
COMPILE_TARGET = cloudflared_compile

include ../../mk/spksrc.cross-go.mk

.PHONY: cloudflared_compile
cloudflared_compile:
	@$(MSG) "- Build cloudflared"
	@$(RUN) $(MAKE) VERSION=$(PKG_VERS) LINK_FLAGS="-s -w" cloudflared
