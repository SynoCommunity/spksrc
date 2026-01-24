PKG_NAME = node_exporter
PKG_VERS = 1.8.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/prometheus/node_exporter/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

UNSUPPORTED_ARCHS = $(PPC_ARCHS)
include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
BUILD_DEPENDS = native/go_1.23
NATIVE_GO = native/go_1.23
else
BUILD_DEPENDS = native/go
NATIVE_GO = native/go
endif

HOMEPAGE = https://github.com/prometheus/node_exporter
COMMENT  = Prometheus exporter for hardware and OS metrics exposed by *NIX kernels.
LICENSE  = Apache 2.0

COMPILE_MAKE_OPTIONS += build

CGO_ENABLED = 1
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk
