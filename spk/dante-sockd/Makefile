SPK_NAME = dante-sockd
SPK_VERS = 1.4.2
SPK_REV = 1
SPK_ICON = src/dante.png

REQUIRED_DSM = 5.0

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Anonym-tsk
# From Inferno Nettverk A/S
DESCRIPTION = Dante implements the socks standard and can function as a firewall between networks. Package contains sockd - socks proxyserver.
DESCRIPTION_FRE = Dante fournit le service socks et peut servir de firewall entre réseaux. Le package contient sockd - un serveur proxy socks.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Dante Sockd
CHANGELOG =

HOMEPAGE = https://www.inet.no/dante/
LICENSE  = BSD

WIZARDS_DIR = src/wizard/

SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = sockd_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: sockd_extra_install
sockd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/sockd.conf $(STAGING_DIR)/var/sockd.conf
