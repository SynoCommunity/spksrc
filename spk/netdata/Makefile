SPK_NAME = netdata
SPK_VERS = 2.10.4
SPK_REV = 2
SPK_ICON = src/netdata.png

DEPENDS = cross/netdata

REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS) comcerto2k

MAINTAINER = SynoCommunity
DISPLAY_NAME = Netdata
DESCRIPTION = Real-time performance monitoring, done right! Monitor your system with beautiful, interactive dashboards.
CHANGELOG = "1. Update Netdata to v2.10.4. <br/>2. Add systemd journal log viewing."

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
