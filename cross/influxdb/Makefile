PKG_NAME = influxdb
PKG_VERS = 1.7.6
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/influxdata/influxdb/archive
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

HOMEPAGE = https://github.com/influxdata/influxdb
COMMENT  = InfluxDB is a time series database designed to handle high write and query loads.
LICENSE  = MIT

DEPENDS = native/go native/dep

CONFIGURE_TARGET = influxdb_configure
COMPILE_TARGET = influxdb_compile
INSTALL_TARGET = influxdb_install

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

INFLUXDB_DIR = $(WORK_DIR)/src/github.com/influxdata/$(PKG_NAME)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/influxdata
INFLUXDB_BIN = $(WORK_DIR)/bin/linux_arm

ENV += GOPATH="$(WORK_DIR)" \
		GOOS=linux \
		GOARCH="$(GO_ARCH)" \
		PATH=$(WORK_DIR)/../../../native/go/work-native/go/bin/:$(WORK_DIR)/../../../native/dep/work-native/bin/:$$PATH

.PHONY: influxdb_configure
influxdb_configure:
	mv $(WORK_DIR)/src/github.com/influxdata/$(PKG_NAME)-$(PKG_VERS) $(WORK_DIR)/src/github.com/influxdata/$(PKG_NAME)
	cd $(INFLUXDB_DIR) && env $(ENV) dep ensure

.PHONY: influxdb_compile
influxdb_compile:
	cd $(INFLUXDB_DIR) && env $(ENV) go install -v "github.com/influxdata/influxdb/cmd/..."
	
.PHONY: influxdb_install
influxdb_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	install -m 0755 $(INFLUXDB_BIN)/* $(STAGING_INSTALL_PREFIX)/bin
