PKG_NAME = node_exporter
PKG_VERS = 0.18.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/prometheus/node_exporter/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS = native/go

HOMEPAGE = https://github.com/prometheus/node_exporter
COMMENT  = Prometheus exporter for hardware and OS metrics exposed by *NIX kernels
LICENSE  = Apache License 2.0

CONFIGURE_TARGET = nop
COMPILE_TARGET = node_exporter_target
INSTALL_TARGET = node_exporter_install

include ../../mk/spksrc.cross-cc.mk

UNSUPPORTED_ARCHS = $(PPC_ARCHES)

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
GO_ARCH = arm
ENV += GOARM=5
endif
ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
GO_ARCH = arm
ENV += GOARM=7
endif
ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
GO_ARCH = arm64
endif
ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
GO_ARCH = 386
endif
ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
GO_ARCH = amd64
endif
ifeq ($(GO_ARCH),)
$(error Unsupported ARCH $(ARCH))
endif

ENV += GOPATH=$(WORK_DIR)
ENV += GOOS=linux
ENV += GOARCH="$(GO_ARCH)"
ENV += CGO_ENABLED=1
ENV += PATH=$(WORK_DIR)/../../../native/go/work-native/go/bin/:$$PATH

NODE_EXPORTER_BIN = $(WORK_DIR)/$(PKG_DIR)/node_exporter

node_exporter_target:
	$(RUN) make build

node_exporter_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(NODE_EXPORTER_BIN) $(STAGING_INSTALL_PREFIX)/bin/

