PKG_NAME = fan2go
PKG_VERS = 0.9.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/markusressel/fan2go/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go cross/lm-sensors
DEPENDS = cross/lm-sensors

HOMEPAGE = https://github.com/markusressel/fan2go
COMMENT  = A simple daemon providing dynamic fan speed control based on temperature sensors.
LICENSE  = AGPLv3

GO_SRC_DIR  = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR  = $(GO_SRC_DIR)/$(PKG_NAME)
CGO_ENABLED = 1
ENV        += CGO_CFLAGS="-I$(STAGING_INSTALL_PREFIX)/include"
ENV        += CGO_LDFLAGS="-L$(STAGING_INSTALL_PREFIX)/lib"

include ../../mk/spksrc.cross-go.mk
