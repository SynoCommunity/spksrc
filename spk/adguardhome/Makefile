SPK_NAME = adguardhome
SPK_VERS = 0.107.71
SPK_REV = 0
SPK_ICON = src/adguardhome.png

DEPENDS = cross/adguardhome
UNSUPPORTED_ARCHS = $(PPC_ARCHS)
SPK_CONFLICT = DNSServer DhcpServer

MAINTAINER = publicarray
DISPLAY_NAME = AdGuardHome
DESCRIPTION = "Network-wide ads & trackers blocking DNS server"
HOMEPAGE = https://adguard.com/en/adguard-home/overview.html
LICENSE = GPL-3.0
CHANGELOG = "Initial release"

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT  = 6053
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard

include ../../mk/spksrc.spk.mk
