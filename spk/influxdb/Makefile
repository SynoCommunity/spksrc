SPK_NAME = influxdb
SPK_VERS = 2.7.4
SPK_REV = 1
SPK_ICON = src/influxdb.png

DEPENDS = cross/influxdb2 cross/influxdb2-client

MAINTAINER = SynoCommunity
DESCRIPTION = InfluxDB is an open-source time series database developed by the company InfluxData. It is written in the Go programming language for storage and retrieval of time series data in fields such as operations monitoring, application metrics, Internet of Things sensor data, and real-time analytics. It also has support for processing data from Graphite. This package includes both the database and CLI client
STARTABLE = yes
DISPLAY_NAME = InfluxDB
CHANGELOG = "1. Created initial package"

HOMEPAGE = https://www.influxdata.com/products/influxdb/
LICENSE  = Apache-2.0/MIT

# There does not exist a 32 bit package
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

# WIZARDS_DIR = src/wizard/

include ../../mk/spksrc.common.mk

SPK_COMMANDS = bin/influx bin/influxd

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8186
SERVICE_PORT_TITLE = InfluxDB API

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = influxdb_extra_install

include ../../mk/spksrc.spk.mk

# Install src/config.yml to var
.PHONY: influxdb_extra_install
influxdb_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/config.yml $(STAGING_DIR)/var/config.yml
