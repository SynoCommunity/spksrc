PKG_NAME = proxmoxbackupclient_go
PKG_VERS = 0.0.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tizbac/proxmoxbackupclient_go/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# golang not supported
UNSUPPORTED_ARCHS = $(PPC_ARCHS)
# lacking support for atomics
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://github.com/tizbac/proxmoxbackupclient_go/
COMMENT  = In development proxmox backup client written in golang, aimed at windows compatibility.
LICENSE  = GPL v3

# REMARKS:
# we patch the sources to get rid of windows dependencies.

CGO_ENABLED = 1
GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/proxmoxbackupgo

include ../../mk/spksrc.cross-go.mk
