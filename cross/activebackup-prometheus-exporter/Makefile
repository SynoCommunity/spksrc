PKG_NAME = activebackup-prometheus-exporter
PKG_VERS = 1.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = "v$(PKG_VERS).$(PKG_EXT)"
PKG_DIST_SITE = "https://github.com/codemonauts/$(PKG_NAME)/archive"
PKG_DIST_FILE = "$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)"
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)


DEPENDS = native/go

HOMEPAGE = https://github.com/codemonauts/activebackup-prometheus-exporter
COMMENT  = Prometheus exporter for the ActiveBackup program suite 
LICENSE  = MIT

COMPILE_TARGET = activebackup_exporter_compile

CGO_ENABLED = 1
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk


activebackup_exporter_compile:
	$(RUN) make build
