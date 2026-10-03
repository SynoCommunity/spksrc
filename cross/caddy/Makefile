PKG_NAME = caddy
PKG_VERS = 2.11.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/caddyserver/caddy/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://caddyserver.com/
COMMENT  = Fast, multi-platform web server with automatic HTTPS
LICENSE  = Apache-2.0

# Go has no 32-bit PowerPC target, and whatever's still alive in this group
# (qoriq and older) has never had a Go build attempted here.
UNSUPPORTED_ARCHS = $(PPC_ARCHS)
# hi3535 (ARMv7L): building from source removes the prebuilt-binary
# ABI-match concern that used to exclude it, but nobody has asked for it or
# tested it here yet - worth revisiting on request.
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

# Caddy's own module path: `go build` from here (its documented manual
# build method - see cmd/caddy in upstream) produces a plain "caddy"
# binary, fully static (CGO_ENABLED=0 is env-go.mk's default) same as the
# upstream release binaries this package used to download instead.
GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/cmd/caddy
GO_BIN_DIR = $(GO_SRC_DIR)/caddy

include ../../mk/spksrc.cross-go.mk
