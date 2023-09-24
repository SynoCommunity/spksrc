SPK_NAME = influxdb
SPK_VERS = 2.7.1
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

UNSUPPORTED_ARCHS = $(32bit_ARCHS)

include ../../mk/spksrc.common.mk

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8086
SERVICE_PORT_TITLE = InfluxDB API

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
