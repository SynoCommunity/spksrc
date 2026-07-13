PKG_NAME = loom
PKG_VERS = 0.2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-source-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Ebenderooock/loom/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Pinned upstream release commit so buildinfo.Commit is accurate without hitting
# the (rate-limited) GitHub API at build time. Bump together with PKG_VERS.
PKG_COMMIT = 7f34860

BUILD_DEPENDS = native/go

# Go does not support ppc32 and Go 1.26 dropped ARMv5. Keep in sync with spk/loom.
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://loom.deroock.co.za
COMMENT  = Loom is a unified, self-hosted media automation server (a Radarr/Sonarr/Prowlarr/Overseerr replacement).
LICENSE  = AGPL-3.0

# The release tarball wraps everything in a top-level $(PKG_DIR)/ directory and
# the Go main package lives in cmd/loom. Loom uses the pure-Go
# modernc.org/sqlite driver (CGO is disabled by the framework) and embeds the
# prebuilt web/dist via the `embed` build tag, so neither a C cross-toolchain
# nor a Node toolchain is required. The framework derives the compile/install
# targets from GO_SRC_DIR/GO_BIN_DIR, so no custom COMPILE_TARGET is needed.
#
# The `no_builtin_torrent` tag disables Loom's built-in torrent download kind,
# which only works alongside an external Rain sidecar daemon (deployed by the
# Helm chart in container setups). This single-binary package ships no such
# sidecar, so the kind is hidden in the UI and rejected by the API; users point
# Loom at a standalone download client (qBittorrent, Transmission, etc.) instead.
GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/cmd/loom
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

GO_BUILD_ARGS = -trimpath -tags "embed no_builtin_torrent"

GO_LDFLAGS  = -s -w
GO_LDFLAGS += -X github.com/ebenderooock/loom/internal/buildinfo.Version=$(PKG_VERS)
GO_LDFLAGS += -X github.com/ebenderooock/loom/internal/buildinfo.Commit=$(PKG_COMMIT)
GO_LDFLAGS += -X github.com/ebenderooock/loom/internal/buildinfo.Date=$(shell date -u +%Y-%m-%dT%H:%M:%SZ)

include ../../mk/spksrc.cross-go.mk
