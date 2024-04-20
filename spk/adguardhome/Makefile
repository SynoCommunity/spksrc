SPK_NAME = adguardhome
SPK_VERS = 0.107.48
SPK_REV = 0
SPK_ICON = src/adguardhome.png

DEPENDS = cross/adguardhome
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = publicarray
DISPLAY_NAME = AdGuardHome
DESCRIPTION = "Network-wide ads & trackers blocking DNS server"
HOMEPAGE = https://adguard.com/en/adguard-home/overview.html
LICENSE = Apache-2.0
CHANGELOG = "First Release"

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
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/AdGuardHome.yml $(STAGING_DIR)/var/AdGuardHome.yml