PKG_NAME = node_exporter
PKG_VERS = 0.18.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/prometheus/node_exporter/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/go

HOMEPAGE = https://github.com/prometheus/node_exporter
COMMENT  = Prometheus exporter for hardware and OS metrics exposed by *NIX kernels
LICENSE  = Apache License 2.0

COMPILE_TARGET = node_exporter_compile

CGO_ENABLED = 1
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk


node_exporter_compile:
	$(RUN) make build
