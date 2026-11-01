SPK_NAME = adguardhome
SPK_VERS = 0.107.77
SPK_REV = 1
SPK_ICON = src/adguardhome.png

DEPENDS = cross/adguardhome
UNSUPPORTED_ARCHS = $(PPC_ARCHS)
SPK_CONFLICT = DNSServer DhcpServer

MAINTAINER = publicarray
DISPLAY_NAME = AdGuardHome
DESCRIPTION = Network-wide ads & trackers blocking DNS server
HOMEPAGE = https://adguard.com/en/adguard-home/overview.html
LICENSE = GPL-3.0
CHANGELOG = "1. Initial release for AdGuard Home v0.107.77."

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT  = 6053
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard

POST_STRIP_TARGET = adguardhome_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: adguardhome_extra_install
adguardhome_extra_install:
	@$(MSG) Install adguardhome fix script
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/adguardhome-fix $(STAGING_DIR)/bin/adguardhome-fix
