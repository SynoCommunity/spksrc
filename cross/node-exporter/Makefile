PKG_NAME = node_exporter
PKG_VERS = 1.10.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/prometheus/node_exporter/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

MIN_GO_VERSION = 1.24.0

HOMEPAGE = https://github.com/prometheus/node_exporter
COMMENT  = Prometheus exporter for hardware and OS metrics exposed by *NIX kernels.
LICENSE  = Apache 2.0

COMPILE_ARGS += build

CGO_ENABLED = 1
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk
