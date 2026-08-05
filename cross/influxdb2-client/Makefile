PKG_NAME = influxdb2-client
PKG_VERS = 2.7.3
PKG_EXT = tar.gz
PKG_DIST_SITE = https://dl.influxdata.com/influxdb/releases
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-linux-$(PKG_DIST_ARCH).$(PKG_EXT)

DEPENDS =

HOMEPAGE = https://www.influxdata.com/products/influxd/
COMMENT  = InfluxDB is an open-source time series database developed by the company InfluxData. It is written in the Go programming language for storage and retrieval of time series data in fields such as operations monitoring, application metrics, Internet of Things sensor data, and real-time analytics. It also has support for processing data from Graphite. This package is the CLI client which connects to the database.
LICENSE  = Apache-2.0/MIT

INSTALL_TARGET = influxdb2-client_install

UNSUPPORTED_ARCHS = $(32bit_ARCHS)

PKG_DIST_ARCH_LIST = amd64 arm64

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = amd64
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
endif

include ../../mk/spksrc.install-resources.mk

.PHONY: influxdb2-client_install
influxdb2-client_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/influx $(STAGING_INSTALL_PREFIX)/bin
