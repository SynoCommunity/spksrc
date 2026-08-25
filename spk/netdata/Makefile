SPK_NAME = netdata
SPK_VERS = 2.11.0
SPK_REV = 3
SPK_ICON = src/netdata.png

DEPENDS = cross/netdata

# netdata compiles C++17 -- gcc 7.5 or newer (verified against the oldest DSM 7 toolchain)
MIN_GCC_VERSION = 7.5

REQUIRED_MIN_DSM = 7.0

MAINTAINER = SynoCommunity
DISPLAY_NAME = Netdata
DESCRIPTION = Real-time performance monitoring, done right! Monitor your system with beautiful, interactive dashboards.
CHANGELOG = "1. Update Netdata to v2.11.0."

HOMEPAGE = https://www.netdata.cloud
HELPURL = https://docs.synocommunity.com/packages/netdata/
LICENSE = GPLv3

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

ADMIN_PORT = 19999
SERVICE_PORT = $(ADMIN_PORT)
SERVICE_PORT_TITLE = Netdata (HTTP)
FWPORTS = src/netdata.sc
WIZARDS_DIR = src/wizard/
SPK_COMMANDS = bin/netdata-fix bin/pgrep

POST_STRIP_TARGET = netdata_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: netdata_extra_install
netdata_extra_install:
	@$(MSG) Install netdata fix script
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/netdata-fix $(STAGING_DIR)/bin/netdata-fix
	@$(MSG) Install default netdata configuration
	install -m 755 -d $(STAGING_DIR)/var/etc/netdata
	install -m 644 src/var/etc/netdata/netdata.conf $(STAGING_DIR)/var/etc/netdata/
