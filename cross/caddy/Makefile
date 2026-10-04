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

# Caddy's own module path: `go build` from here (its documented manual
# build method - see cmd/caddy in upstream) produces a plain "caddy"
# binary, fully static (CGO_ENABLED=0 is env-go.mk's default) same as the
# upstream release binaries this package used to download instead.
GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/cmd/caddy
GO_BIN_DIR = $(GO_SRC_DIR)/caddy

# `go build` from a release tarball has no VCS or module version to stamp, so
# `caddy version` would report "unknown"; caddy.go documents this ldflag for it.
GO_BUILD_ARGS += -ldflags '-X github.com/caddyserver/caddy/v2.CustomVersion=v$(PKG_VERS)'

include ../../mk/spksrc.cross-go.mk
