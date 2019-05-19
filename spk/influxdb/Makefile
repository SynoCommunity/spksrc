SPK_NAME = influxdb
SPK_VERS = 1.7.6
SPK_REV = 2
SPK_ICON = src/influxdb.png

DEPENDS = cross/$(SPK_NAME)
UNSUPPORTED_ARCHES = $(PPC_ARCHES)

MAINTAINER = terual
DESCRIPTION = InfluxDB is a time series database designed to handle high write and query loads.
DISPLAY_NAME = InfluxDB
CHANGELOG = "New package"
RELOAD_UI = yes
STARTABLE = yes

HELPURL = https://docs.influxdata.com/influxdb
LICENSE = MIT

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8086
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

POST_STRIP_TARGET = influxdb_extra_install

include ../../mk/spksrc.spk.mk

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

INFLUXDB_DIR = $(WORK_DIR)/src/github.com/influxdata/$(SPK_NAME)

.PHONY: influxdb_extra_install
influxdb_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	#install -m 644 $(INFLUXDB_DIR)/etc/config.sample.toml $(STAGING_DIR)/var/influxdb.conf
	install -m 644 src/influxdb.conf $(STAGING_DIR)/var/influxdb.conf
	
